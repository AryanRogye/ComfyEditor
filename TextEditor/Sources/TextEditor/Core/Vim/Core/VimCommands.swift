//
//  VimCommands.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import LocalShortcuts

extension VimEngine {
    
    static let escape = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.escape]
    )
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
    static let visual_line_mode = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.V]
    )
    static let command_mode = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.semi_colon]
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
    static let move_word_next_trailing = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.e]
    )
    static let move_word_back = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.b]
    )
    static let move_end_line_insert = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.A]
    )
    static let move_end_of_line = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.dollar]
    )
    static let move_start_of_line = LocalShortcuts.Shortcut(
        modifier: [.shift],
        keys: [.underscore]
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
    static let delete = LocalShortcuts.Shortcut(
        modifier: [],
        keys: [.x]
    )
}
