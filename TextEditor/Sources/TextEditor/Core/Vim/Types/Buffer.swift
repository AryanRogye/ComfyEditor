//
//  Buffer.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//
import AppKit

public protocol BufferView {
    func currentVisualHead(anchor: Int?) -> Position?
    func cursorOffset() -> Int
    func moveTo(position: Position)
    func getCursorPosition() -> NSRange?
    func cursorPosition() -> Position
    func lineCount() -> Int
    func line(at index: Int) -> String
    func char(at pos: Position) -> Character?
}
