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
    
    internal func handleVimEvent(_ event: NSEvent) {
        /// we can get the key from the event
        let shortcut : LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)
        
        /// Shortcut holds all modifiers and keys
        /// First Check if is control c
        
        
        switch shortcut {
        case Self.normal_mode:  vimEngine.state = .normal
        case Self.insert_mode:  vimEngine.state = .insert
        case Self.visual_mode:  vimEngine.state = .visual
        default:                break
        }
    }
}
