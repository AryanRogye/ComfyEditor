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
    
    public func updatePosition() {
        let p = fsmEngine.nsTextViewBuffer.cursorPosition()
        position = p
        if let c = fsmEngine.nsTextViewBuffer.char(at: p) {
            isOnNewLine = c == "\n"
        }
    }

    init() {
    }
    
    public func handleVimEvent(_ event: NSEvent) -> Bool {
        /// we can get the key from the event
        let shortcut: LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)
        
        /// Shortcut holds all modifiers and keys
        /// First Check if is control c
        
        var didJustInsert: Bool = false
        var didJustMoveToEndOfLine: Bool = false
        /// Used as validation
        //        print("SET" + Self.move_end_line.modifiers())
        //        print("SET" + Self.move_end_line.keyValues())
        //        print("====================================")
        //        print("INPUT" + shortcut.modifiers())
        //        print("INPUT" + shortcut.keyValues())
        //        print("====================================")
        
        switch shortcut {
            
            /// User Requested Normal Mode
        case Self.normal_mode:
            state = .normal
            /// User Requested Insert Mode
        case Self.insert_mode:
            state = .insert
            didJustInsert = true
            
        case Self.visual_mode: state = .visual
            
        case Self.move_left_one:
            if state == .normal {
                moveLeft()
            }
        case Self.move_right_one:
            if state == .normal {
                moveRight()
            }
        case Self.move_up_one:
            if state == .normal {
                moveUp()
            }
        case Self.move_down_one:
            if state == .normal {
                moveDown()
            }
            
        case Self.move_word_next_leading:
            if state == .normal {
                handleNextWordLeading()
            }
            
        case Self.move_word_back:
            if state == .normal {
                handleLastWordLeading()
            }
            
        case Self.move_end_line:
            if state == .normal {
                didJustMoveToEndOfLine = true
                moveToEndOfLine()
                state = .insert
            }
        case Self.bottom_of_file:
            if state == .normal {
                moveToBottomOfFile()
            }
        case Self.g_modifier:
            if state == .normal {
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
        if let textView = fsmEngine.nsTextViewBuffer.textView {
            textView.updateInsertionPointStateAndRestartTimer(true)
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
}
