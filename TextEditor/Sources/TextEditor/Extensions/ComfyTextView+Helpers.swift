//
//  ComfyTextView+Helpers.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension ComfyTextView {
    /// Move right by a certain amount
    public func moveRight(_ count: Int = 1) {
        for _ in 0..<count {
            moveRight(self)
        }
    }
    public func moveLeft(_ count: Int = 1) {
        for _ in 0..<count {
            moveLeft(self)
        }
    }
}
