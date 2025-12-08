//
//  NSTextViewBufferAdapter.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import AppKit

public final class NSTextViewBufferAdapter: BufferView {
    weak var textView: NSTextView?
    
    public func moveTo(position: Position) {
        guard let textView = textView else { return }
        let string = textView.string as NSString
        let totalLength = string.length
        
        var currentLine = 0
        var charIndex = 0
        
        /// 1. Find the Start Index of the Target Line
        /// We assume your 'Position.line' is 0-indexed.
        while currentLine < position.line && charIndex < totalLength {
            // lineRange(for:) gives us the full range of the line including the newline
            let range = string.lineRange(for: NSRange(location: charIndex, length: 0))
            charIndex = NSMaxRange(range)
            currentLine += 1
        }
        
        /// 2. Calculate Target Index with Column
        /// Now 'charIndex' is at the start of the correct line.
        let lineRange = string.lineRange(for: NSRange(location: charIndex, length: 0))
        
        // Check if the line actually has a newline character at the end so we don't skip it
        var lineEndIndex = NSMaxRange(lineRange)
        
        // If the line ends with a newline, we usually want the cursor to stop BEFORE it
        // unless you specifically want to allow the cursor to wrap.
        // Vim-like behavior: clamp to the last character, not the newline.
        if lineEndIndex > 0 {
            let lastCharRange = NSRange(location: lineEndIndex - 1, length: 1)
            if lastCharRange.location < totalLength {
                let lastChar = string.substring(with: lastCharRange)
                if lastChar == "\n" || lastChar == "\r" {
                    lineEndIndex -= 1
                }
            }
        }
        
        // Add column, but clamp so we don't go past the end of the line
        let desiredIndex = charIndex + position.column
        let finalIndex = min(desiredIndex, lineEndIndex)
        
        /// 3. Apply Selection
        textView.setSelectedRange(NSRange(location: finalIndex, length: 0))
        textView.scrollRangeToVisible(NSRange(location: finalIndex, length: 0))
    }
    
    public func getCursorPosition() -> NSRange? {
        guard let textView else { return nil }
        return textView.selectedRange
    }
    
    public func cursorPosition() -> Position {
        /// if no textView return 0,0
        guard let textView else {
            return Position(line: 0, column: 0)
        }
        guard let textStorage = textView.textStorage else { return Position(line: 0, column: 0) }
        
        let cursorPosition = textView.selectedRanges[0].rangeValue.location
        let text = textStorage.string as NSString
        
        var lineCount = 0
        var lineStart = 0
        
        // Iterate through each line by finding newlines
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { _, substringRange, _, stop in
            if cursorPosition >= substringRange.location && cursorPosition <= NSMaxRange(substringRange) {
                let column = cursorPosition - substringRange.location
                stop.pointee = true
                return
            }
            lineCount += 1
        }
        
        // Calculate column for the found line
        var lineStartIndex = 0
        var currentLine = 0
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { _, substringRange, _, stop in
            if currentLine == lineCount {
                lineStartIndex = substringRange.location
                stop.pointee = true
            }
            currentLine += 1
        }
        
        let column = cursorPosition - lineStartIndex
        return Position(line: lineCount, column: column)
    }
    
    public func lineCount() -> Int {
        guard let textView else { return 0 }
        guard let textStorage = textView.textStorage else { return 0 }
        
        let text = textStorage.string as NSString
        var count = 0
        
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { _, _, _, _ in
            count += 1
        }
        
        return count
    }
    
    public func char(at pos: Position) -> Character? {
        guard let textView else { return nil }
        guard let textStorage = textView.textStorage else { return nil }
        
        let text = textStorage.string as NSString
        let row = pos.line
        let col = pos.column
        
        var currentLine = 0
        var result: Character? = nil
        
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { _, substringRange, enclosingRange, stop in
            if currentLine == row {
                // Calculate the absolute position in the text
                let charPosition = substringRange.location + col
                
                // Check if column is within bounds of this line
                if charPosition < NSMaxRange(enclosingRange) && charPosition < text.length {
                    let char = text.character(at: charPosition)
                    result = Character(UnicodeScalar(char)!)
                }
                stop.pointee = true
            }
            currentLine += 1
        }
        
        return result
    }
    
    public func line(at index: Int) -> String {
        guard let textView else { return "" }
        guard let textStorage = textView.textStorage else { return "" }
        
        let text = textStorage.string as NSString
        var currentLine = 0
        var result = ""
        
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { substring, substringRange, enclosingRange, stop in
            if currentLine == index {
                // Use enclosingRange to include the newline character
                result = text.substring(with: enclosingRange)
                stop.pointee = true
            }
            currentLine += 1
        }
        
        return result
    }
}
