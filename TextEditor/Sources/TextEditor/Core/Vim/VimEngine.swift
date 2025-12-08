//
//  VimEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit
import LocalShortcuts

@MainActor
class VimEngine: ObservableObject {
    
    /// if we are in vim or not
    @Published var isInVimMode = false
    /// What the state of vim mode we are in
    @Published var state : VimState = .normal
    
    @Published var position : FSMEngine.Position?
    @Published var isOnNewLine: Bool = false
    
    var lastShortcut: LocalShortcuts.Shortcut?

    /// Engine Powering the Movement Logic
    let fsmEngine = FSMEngine()
    
    var visualAnchorLocation: Int?
    
    public func updatePosition() {
        let p = fsmEngine.nsTextViewBuffer.cursorPosition()
        position = p
        if let c = fsmEngine.nsTextViewBuffer.char(at: p) {
            isOnNewLine = c == "\n"
        }
    }

    init() {
    }
    
    /// Calculates the actual position of the "moving" cursor (The Head).
    /// In NSTextView, `selectedRange.location` is always the start (left side).
    /// We need to know if we are selecting forwards or backwards to find the real head.
    var currentVisualHead: Int {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return 0 }
        
        let range = textView.selectedRange
        let currentLocation = range.location
        
        // If not in visual mode, the head is just the location
        guard state == .visual, let anchor = visualAnchorLocation else {
            return currentLocation
        }
        
        // If the range starts AT the anchor, we are selecting FORWARDS.
        // The Head is at the end of the range.
        if currentLocation == anchor {
            // -1 because Visual Mode is inclusive (cursor is on the last char)
            return max(currentLocation, currentLocation + range.length - 1)
        }
        
        // If the range starts BEFORE the anchor, we are selecting BACKWARDS.
        // The Head is at the location.
        return currentLocation
    }
    
    public func handleVimEvent(_ event: NSEvent) -> Bool {
        /// if not set just keep typing
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return true }
        
        /// we can get the key from the event
        let shortcut: LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)
        
        /// Shortcut holds all modifiers and keys
        /// First Check if is control c
        
        var didJustInsert: Bool = false
        var didJustMoveToEndOfLine: Bool = false
        
        let rang = textView.selectedRange
        print("BEFORE Cursor Selection for Visual with: \(rang.location)")

        switch shortcut {
            
            /// User Requested Normal Mode
        case Self.normal_mode:
            if state == .visual { exitVisualMode() }
            state = .normal
            /// User Requested Insert Mode
        case Self.insert_mode:
            if state == .visual { exitVisualMode() }
            state = .insert
            didJustInsert = true
            
        case Self.visual_mode:
            /// Handles Visual Mode Selection and flipping logic
            enterVisualMode()
            
            
        /// MOVEMENT
        case Self.move_left_one:
            if state != .insert {
                moveLeft()
            }
        case Self.move_right_one:
            if state != .insert {
                moveRight()
            }
        case Self.move_up_one:
            if state != .insert {
                moveUp()
            }
        case Self.move_down_one:
            if state != .insert {
                moveDown()
            }
            
        case Self.move_word_next_leading:
            if state != .insert {
                handleNextWordLeading()
            }
        case Self.move_word_next_trailing:
            if state != .insert {
                handleNextWordTrailing()
            }
        case Self.move_word_back:
            if state != .insert {
                handleLastWordLeading()
            }
            
        case Self.move_end_line:
            if state != .insert {
                didJustMoveToEndOfLine = true
                moveToEndOfLine()
                state = .insert
            }
        case Self.bottom_of_file:
            if state != .insert {
                moveToBottomOfFile()
            }
        case Self.g_modifier:
            if state != .insert {
                if let lastShortcut = lastShortcut {
                    let top_of_file_pattern: [LocalShortcuts.Shortcut] = [
                        lastShortcut,
                        Self.g_modifier,
                    ]
                    if top_of_file_pattern == Self.top_of_file {
                        moveToTopOfFile()
                    }
                }
            }
        default: break
        }
        
        lastShortcut = shortcut
        
        /// Update's the insertion point
        textView.updateInsertionPointStateAndRestartTimer(true)
        
        /// If In Visual Mode
        if state == .visual {
            /// Get Cursor Position to move right by 1
            if let range = fsmEngine.nsTextViewBuffer.getCursorPosition() {
                print("Updating Cursor Selection for Visual with: \(range.location)")
                updateCursorAndSelection(to: range.location)
            }
        }
        
        refreshFSM()
        
        if didJustInsert || didJustMoveToEndOfLine {
            return false
        }
        
        return state == .insert
    }
    
    /// Represents Vim-style `w` behavior across lines.
    ///
    /// Example:
    ///
    ///     something here testing o
    ///                         ^ cursor (*HERE*)
    ///     testing something out here too
    ///
    /// Pressing `w` moves the cursor to:
    ///
    ///     something here testing o
    ///     testing something out here too
    ///     ^ cursor (*HERE*)
    /// Because next word is newline, on newline, we call our function
    /// to move down and to the start of the line
    private func moveDownAndStartOfLine() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveDown(textView)
        textView.moveToBeginningOfLine(textView)
    }
    
    private func refreshFSM() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        EditorCommandCenter.shared.textViewDelegate.refresh(textView)
    }
    private func enterVisualMode() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        visualAnchorLocation = textView.selectedRange.location
        state = .visual
    }
    
    func exitVisualMode() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        visualAnchorLocation = nil
        let cursor = textView.selectedRange.location
        textView.setSelectedRange(NSRange(location: cursor, length: 0))
    }

    private func updateCursorAndSelection(to newCursor: Int) {
        guard let textView = fsmEngine.nsTextViewBuffer.textView,
              let textStorage = textView.textStorage else { return }
        
        let totalLength = textStorage.length
        
        /// 1. Safety Clamp: Ensure cursor never reports outside valid string bounds
        let safeCursor = min(max(newCursor, 0), totalLength)
        
        guard let anchor = visualAnchorLocation else {
            // Not in visual mode – just move cursor (length 0)
            textView.setSelectedRange(NSRange(location: safeCursor, length: 0))
            return
        }
        
        /// 2. Calculate Min/Max for the range
        let start = min(anchor, safeCursor)
        let end   = max(anchor, safeCursor)
        
        /// 3. Calculate Length (Inclusive)
        /// Vim Visual mode is inclusive, so we add +1 to include the character at 'end'.
        var length = end - start + 1
        
        /// 4. Final Bounds Check
        /// If the calculation tries to select past the end of the file (e.g. cursor is at EOF),
        /// we must clamp the length so we don't crash.
        if start + length > totalLength {
            length = totalLength - start
        }
        
        /// 5. Apply
        if length > 0 {
            textView.setSelectedRange(NSRange(location: start, length: length))
        } else {
            /// Fallback for edge cases (like empty file)
            textView.setSelectedRange(NSRange(location: start, length: 0))
        }
    }
}
