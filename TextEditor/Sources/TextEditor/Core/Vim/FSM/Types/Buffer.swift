//
//  Buffer.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//
import AppKit

extension FSMEngine {
    public protocol BufferView {
        func getTextView() -> NSTextView?
        func getCursorPosition() -> NSRange?
        func cursorPosition() -> Position
        func lineCount() -> Int
        func line(at index: Int) -> String
        func char(at pos: Position) -> Character?
    }
}
