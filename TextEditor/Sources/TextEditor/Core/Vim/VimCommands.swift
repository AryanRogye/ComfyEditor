//
//  VimCommands.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import LocalShortcuts

extension VimEngine {
    
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
    static let move_word_next_leading = LocalShortcuts.Shortcut(
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
        ),
    ]
}
