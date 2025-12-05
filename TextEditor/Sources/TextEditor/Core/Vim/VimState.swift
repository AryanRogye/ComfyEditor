//
//  VimState.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

enum VimState: String {
    /// Sometimes alternal `Vim` in its mode is normal
    case normal = "Vim"
    case insert = "Insert"
    case visual = "Visual"
}
