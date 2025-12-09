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
    
    @Published var position : Position?
    @Published var isOnNewLine: Bool = false
    
    var lastShortcut: LocalShortcuts.Shortcut?

    public let nsTextViewBuffer = NSTextViewBufferAdapter()
    internal lazy var motionEngine = MotionEngine(buffer: nsTextViewBuffer)

    @Published var visualAnchorLocation: Int?
    
    public func updatePosition() {
        let p = nsTextViewBuffer.cursorPosition()
        position = p
        if let c = nsTextViewBuffer.char(at: p) {
            isOnNewLine = c == "\n"
        }
    }

    init() {}
    
    
    public func handleVimEvent(_ event: NSEvent) -> Bool {
        /// if not set just keep typing
        guard let textView = nsTextViewBuffer.textView else { return true }
        
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
            if let range = nsTextViewBuffer.getCursorPosition() {
                updateCursorAndSelection(to: range.location)
            }
        }
        
        refreshFSM()
        
        if didJustInsert || didJustMoveToEndOfLine {
            return false
        }
        
        return state == .insert
    }
    
    private func refreshFSM() {
        guard let textView = nsTextViewBuffer.textView else { return }
        EditorCommandCenter.shared.textViewDelegate.refresh(textView)
    }
    
    private func enterVisualMode() {
        visualAnchorLocation = nsTextViewBuffer.cursorOffset()
        state = .visual
    }
    private func exitVisualMode() {
        guard let textView = nsTextViewBuffer.textView else { return }
        visualAnchorLocation = nil
        let cursor = textView.selectedRange.location
        textView.setSelectedRange(NSRange(location: cursor, length: 0))
    }

    private func updateCursorAndSelection(to newCursor: Int) {
        guard let textView = nsTextViewBuffer.textView,
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
