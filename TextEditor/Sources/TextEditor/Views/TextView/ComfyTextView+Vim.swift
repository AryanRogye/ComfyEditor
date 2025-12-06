//
//  ComfyTextView+Vim.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit
import LocalShortcuts

extension ComfyTextView {
    
    static let normal_mode = LocalShortcuts.Shortcut(
        modifier: [.control],
        keys: [.c]
    )
    static let insert_mode = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.i]
    )
    static let visual_mode = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.v]
    )
    static let move_left_one = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.h]
    )
    static let move_right_one = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.l]
    )
    static let move_down_one = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.j]
    )
    static let move_up_one = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.k]
    )
    static let move_word_next = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.w]
    )
    static let move_word_back = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.b]
    )
    static let move_end_line = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.A]
    )
    static let bottom_of_file = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.G]
    )
    static let g_modifier = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.g]
    )
    static let top_of_file = [
        LocalShortcuts.Shortcut(
            modifier: [],
            keys: [.g]
        ),
        LocalShortcuts.Shortcut(
            modifier: [],
            keys: [.g]
        )
    ]
    
    
    internal func handleVimEvent(_ event: NSEvent) -> Bool {
        /// we can get the key from the event
        let shortcut : LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)
        
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
            
        case Self.normal_mode:
            vimEngine.state = .normal
            switch shortcut {
            default: break
            }
            
            /// Insert Mode
        case Self.insert_mode:
            vimEngine.state = .insert
            didJustInsert = true
            
        case Self.visual_mode:  vimEngine.state = .visual
            
        case Self.move_left_one:
            if vimEngine.state == .normal  {
                moveLeft(self)
            }
        case Self.move_right_one:
            if vimEngine.state == .normal  {
                moveRight(self)
            }
        case Self.move_up_one:
            if vimEngine.state == .normal  {
                moveUp(self)
            }
        case Self.move_down_one:
            if vimEngine.state == .normal  {
                moveDown(self)
            }
        case Self.move_word_next:
            if vimEngine.state == .normal {
                moveWordRight(self)
                moveRight(self)
            }
        case Self.move_word_back:
            if vimEngine.state == .normal {
                moveWordLeft(self)
            }
        case Self.move_end_line:
            if vimEngine.state == .normal {
                didJustMoveToEndOfLine = true
                moveToRightEndOfLine(self)
                vimEngine.state = .insert
            }
        case Self.bottom_of_file:
            if vimEngine.state == .normal {
                moveToEndOfDocument(self)
            }
        case Self.g_modifier:
            if vimEngine.state == .normal {
                if let lastShortcut = lastShortcut {
                    let top_of_file_pattern : [LocalShortcuts.Shortcut] =  [
                        lastShortcut,
                        Self.g_modifier
                    ]
                    if top_of_file_pattern == Self.top_of_file {
                        moveToBeginningOfDocument(self)
                    }
                }
            }
        default:                break
        }
        
        
        lastShortcut = shortcut
        
        /// Update's the insertion point
        updateInsertionPointStateAndRestartTimer(true)
        
        if didJustInsert || didJustMoveToEndOfLine {
            return false
        }
        
        return vimEngine.state == .insert
    }
}
