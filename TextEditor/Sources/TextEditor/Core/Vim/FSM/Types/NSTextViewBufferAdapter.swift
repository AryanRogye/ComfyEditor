//
//  NSTextViewBufferAdapter.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import AppKit

extension FSMEngine {
    public final class NSTextViewBufferAdapter: BufferView {
        weak var textView: NSTextView?
        
        public func getTextView() -> NSTextView? {
            return textView
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
}
