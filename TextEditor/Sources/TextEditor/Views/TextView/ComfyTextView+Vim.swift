//
//  ComfyTextView+Vim.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit

extension ComfyTextView {
    override func keyDown(with event: NSEvent) {
        if isInVimMode { return }
        super.keyDown(with: event)
    }
}
