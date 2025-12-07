//
//  CursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit
import Combine

@MainActor
final class CursorDelegate: NSObject, TextViewCursorDelegate, ObservableObject {
    
    @Published var charUnderCursor: Character?
    
    @Published var isOnNewline: Bool = false
    @Published var isNextWordNewline: Bool = false
    
    @Published var line: String?
    @Published var wordUnderCursor: String?
    @Published var cursorIndexInLine: Int?
    
    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        
        let range : NSRange = textView.selectedRange
        updateCharUnderCursor(textView, range: range)
        line = getLine(textView, range: range)
        updateWordUnderCursor(textView, range: range)
        
        guard let cursorIndexInLine else { return }
        guard let line else { return }
        
        let isNewLine = line.isNextNewLine(after: cursorIndexInLine + 1)
        let beforeChar = line.char(at: cursorIndexInLine)
        
        isOnNewline = line == "\n"
        
        debugPrint("LINE: \(line)")
        print("IS THE WEIRD PATTERN: \(line == "\n//\n") NEWLINE: \(isNewLine)")
        debugPrint("Word Under Cursor: \(wordUnderCursor) \(beforeChar)")
        isNextWordNewline = (
            isNewLine || (line == "\n//\n")
        )
    }
    
    func nextIsNewline(line: String, cursor: Int) -> Bool {
        guard cursor + 1 < line.count else { return false }
        
        var i = line.index(line.startIndex, offsetBy: cursor + 1)
        
        // skip spaces + tabs ONLY
        while i < line.endIndex && (line[i] == " " || line[i] == "\t") {
            i = line.index(after: i)
        }
        
        return i < line.endIndex && line[i] == "\n"
    }
    
    /// Function is useful for many reasons:
    ///   - Determine what character is under the caret
    ///   - Resolved a bug, with the insertion point
    ///     - if the insertion point is at a \n, it would draw the insertion point all
    ///       the way to the end of the document, instead of the block of newline
    ///     - we now keep a flag isOnNewline to help with that
    private func updateCharUnderCursor(
        _ textView: NSTextView,
        range: NSRange
    ) {
        let string = textView.string
        let utf16Count = string.utf16.count
        
        guard utf16Count > 0 else {
            reset()
            return
        }
        guard range.location < utf16Count else {
            reset()
            return
        }
        
        /// Get Index by getting the start ----> offsetting by caret
        let idx = String.Index(utf16Offset: range.location, in: string)
        /// Get Character at Index from above
        let ch : Character = string[idx]
        
        charUnderCursor = ch
        isOnNewline = ch == "\n"
    }
    
    /// Function gets the line where the caret is currently at
    func getLine(
        _ textView: NSTextView,
        range: NSRange
    ) -> String? {
        let string = textView.string
        let utf16Count = string.utf16.count
        
        guard utf16Count > 0, range.location < utf16Count else {
            return nil
        }
        
        /// This idx is the current caret position
        let idx = String.Index(
            utf16Offset: range.location,
            in: string
        )
        
        /// we can go back to find the last \n
        var start = idx
        
        // Check if we are already at a newline or need to go back
        if start != string.startIndex && start < string.endIndex && string[start] == "\n" {
            /// Return if is a newline
            return "\n"
        }
        
        while start > string.startIndex {
            let prevIdx = string.index(before: start)
            if string[prevIdx] == "\n" {
                start = prevIdx
                break
            }
            start = prevIdx
        }
        
        var end = idx
        while end < string.endIndex {
            let currentChar = string[end]
            if currentChar == "\n" {
                end = string.index(after: end)
                break
            }
            end = string.index(after: end)
        }
        
        cursorIndexInLine = string.distance(from: start, to: idx) - 1
        
        return String(string[start..<end])
    }
    
    func updateWordUnderCursor(_ textView: NSTextView, range: NSRange) {
        let ns = textView.string as NSString
        guard ns.length > 0 else {
            wordUnderCursor = nil
            return
        }
        
        var index = range.location
        if index >= ns.length { index = ns.length - 1 }
        
        // Define what counts as a "word" character
        let wordChars = CharacterSet.alphanumerics
            .union(CharacterSet(charactersIn: "_"))
        
        // --- move left to start of word ---
        var start = index
        while start > 0 {
            let codeUnit = ns.character(at: start - 1)
            guard let scalar = UnicodeScalar(codeUnit) else { break }
            if !wordChars.contains(scalar) { break }
            start -= 1
        }
        
        // --- move right to end of word ---
        var end = index
        while end < ns.length {
            let codeUnit = ns.character(at: end)
            guard let scalar = UnicodeScalar(codeUnit) else { break }
            if !wordChars.contains(scalar) { break }
            end += 1
        }
        
        if end > start {
            let word = ns.substring(with: NSRange(location: start, length: end - start))
            wordUnderCursor = word
        } else {
            wordUnderCursor = nil
        }
        
        print("Word under cursor: \(wordUnderCursor ?? "nil")")
    }
    
    private func reset() {
        charUnderCursor = nil
        isOnNewline = false
    }
}
