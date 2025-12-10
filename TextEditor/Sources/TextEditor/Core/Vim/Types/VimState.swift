//
//  VimState.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

enum VimState {
    /// Sometimes alternal `Vim` in its mode is normal
    case normal
    case insert
    case visual
    case visualLine
}

extension VimState {
    var displayName: String {
        switch self {
        case .normal:
            return "Vim"
        case .insert:
            return "Insert"
        case .visual, .visualLine:
            return "Visual"
        }
    }
}
