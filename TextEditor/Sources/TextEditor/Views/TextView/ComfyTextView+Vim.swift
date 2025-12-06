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

    
    internal func handleVimEvent(_ event: NSEvent) -> Bool {
        /// we can get the key from the event
        let shortcut : LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)
        
        /// Shortcut holds all modifiers and keys
        /// First Check if is control c
        
        
        var didJustInsert: Bool = false
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
        default:                break
        }
        
        /// Update's the insertion point
        updateInsertionPointStateAndRestartTimer(true)
        
        if didJustInsert {
            return false
        }
        
        return vimEngine.state == .insert
    }
}
