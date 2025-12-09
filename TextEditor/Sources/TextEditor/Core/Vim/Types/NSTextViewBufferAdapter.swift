//
//  NSTextViewBufferAdapter.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import AppKit

@MainActor
public final class NSTextViewBufferAdapter: BufferView {
    weak var textView: NSTextView?
    
    public func setTextView(_ textView: NSTextView) {
        self.textView = textView
    }

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

    /// Calculates the actual position of the "moving" cursor (The Head).
    /// In NSTextView, `selectedRange.location` is always the start (left side).
    /// We need to know if we are selecting forwards or backwards to find the real head.
    public func currentVisualHead(anchor: Int?) -> Position? {
        guard let anchor else { return nil }
        guard let textView = textView else { return nil }

        let range = textView.selectedRange
        let currentLocation = range.location

        // If the range starts AT the anchor, we are selecting FORWARDS.
        // The Head is at the end of the range.
        if currentLocation == anchor {
            // -1 because Visual Mode is inclusive (cursor is on the last char)
            let pos = max(currentLocation, currentLocation + range.length - 1)
            return cursorOffsetToPosition(pos)
        }

        // If the range starts BEFORE the anchor, we are selecting BACKWARDS.
        // The Head is at the location.
        return cursorOffsetToPosition(currentLocation)
    }


    private func cursorOffsetToPosition(_ offset: Int?) -> Position? {
        guard let offset else { return nil }
        guard let textView,
              let textStorage = textView.textStorage else {
            return Position(line: 0, column: 0)
        }

        let text = textStorage.string as NSString
        let clampedOffset = min(max(offset, 0), text.length)

        var line = 0
        var lineStart = 0

        text.enumerateSubstrings(
            in: NSRange(location: 0, length: text.length),
            options: .byLines
        ) { _, range, _, stop in

            let lineEnd = NSMaxRange(range)

            if clampedOffset >= range.location && clampedOffset <= lineEnd {
                lineStart = range.location
                stop.pointee = true
                return
            }

            line += 1
        }

        let column = clampedOffset - lineStart
        return Position(line: line, column: column)
    }

    public func cursorOffset() -> Int {
        guard let textView else { return 0 }
        return textView.selectedRanges.first?.rangeValue.location ?? 0
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

        // Iterate through each line by finding newlines
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byLines) { _, substringRange, _, stop in
            if cursorPosition >= substringRange.location && cursorPosition <= NSMaxRange(substringRange) {
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

    public func updateInsertionPoint() {
        guard let textView else { return }
        textView.updateInsertionPointStateAndRestartTimer(true)
        EditorCommandCenter.shared.textViewDelegate.refresh(textView)
    }

    public func exitVisualMode() {
        guard let textView else { return }

        let cursor = textView.selectedRange.location
        let range = NSRange(location: cursor, length: 0)

        textView.setSelectedRange(range)
    }

    public func updateCursorAndSelection(anchor: Int?, to newCursor: Int) {
        guard let textView = textView,
              let textStorage = textView.textStorage else { return }

        let totalLength = textStorage.length

        /// 1. Safety Clamp: Ensure cursor never reports outside valid string bounds
        let safeCursor = min(max(newCursor, 0), totalLength)

        guard let anchor = anchor else {
            // Not in visual mode – just move cursor (length 0)
            textView.setSelectedRange(NSRange(location: safeCursor, length: 0))
            return
        }

        /// 2. Calculate Min/Max for the range
        let start = min(anchor, safeCursor)
        let end   = max(anchor, safeCursor)

        /// 3. Calculate Length (Inclusive)
        /// Vim Visual mode is inclusive, so we add +1 to include the character at 'end'.
        var length = end - start + 1

        /// 4. Final Bounds Check
        /// If the calculation tries to select past the end of the file (e.g. cursor is at EOF),
        /// we must clamp the length so we don't crash.
        if start + length > totalLength {
            length = totalLength - start
        }

        /// 5. Apply
        if length > 0 {
            textView.setSelectedRange(NSRange(location: start, length: length))
        } else {
            /// Fallback for edge cases (like empty file)
            textView.setSelectedRange(NSRange(location: start, length: 0))
        }
    }

    public func moveLeft() {
        guard let textView else { return }
        textView.moveLeft(count: 1)
    }
    public func moveRight() {
        guard let textView else { return }
        textView.moveRight(count: 1)
    }

    public func moveToEndOfLine() {
        guard let textView = textView else { return }
        textView.moveToRightEndOfLine(self)
    }
    public func moveToBottomOfFile() {
        guard let textView = textView else { return }
        textView.moveToEndOfDocument(textView)
    }
    public func moveToTopOfFile() {
        guard let textView = textView else { return }
        textView.moveToBeginningOfDocument(textView)
    }
    public func moveDownAndStartOfLine() {
        guard let textView = textView else { return }
        textView.moveDown(textView)
        textView.moveToBeginningOfLine(textView)

    }
}
