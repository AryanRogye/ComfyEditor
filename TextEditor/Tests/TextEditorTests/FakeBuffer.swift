import AppKit
@testable import TextEditor

final class FakeBuffer: BufferView {

    // MARK: - Stored state

    var lines: [String]

    /// Selected range in the *flattened* string (like NSTextView.selectedRange)
    var selection: NSRange

    /// Not really used in tests, but kept for protocol symmetry
    var visualAnchorOffset: Int?

    /// Only to satisfy `setTextView`, not actually used
    private weak var textView: NSTextView?

    // MARK: - Init

    init(
        lines: [String],
        cursor: Position,
        visualAnchorOffset: Int? = nil
    ) {
        self.lines = lines
        self.visualAnchorOffset = visualAnchorOffset

        let offset = Self.offset(for: cursor, in: lines)
        self.selection = NSRange(location: offset, length: 0)
    }

    // MARK: - BufferView (AppKit-y stuff)

    func setTextView(_ textView: NSTextView) {
        // not needed for tests, but we keep a weak ref if you ever want it
        self.textView = textView
    }

    func updateInsertionPoint() {
        // in real adapter this would touch layout / caret drawing
        // tests don’t care -> no-op
    }

    func exitVisualMode() {
        // collapse selection to caret at the current head
        selection.length = 0
    }

    func updateCursorAndSelection(anchor: Int?, to newCursor: Int) {
        // mimic NSTextView + visual mode:
        // - if no anchor: just move caret
        // - if anchor exists: anchor is fixed, head is at newCursor (inclusive)
        guard let anchor else {
            selection = NSRange(location: newCursor, length: 0)
            return
        }

        if newCursor >= anchor {
            // forward selection, inclusive of head
            selection = NSRange(
                location: anchor,
                length: newCursor - anchor + 1
            )
        } else {
            // backward selection
            selection = NSRange(
                location: newCursor,
                length: anchor - newCursor + 1
            )
        }
    }

    // MARK: - Visual head

    func currentVisualHead(anchor: Int?) -> Position? {
        guard let anchor else { return nil }

        let start = selection.location
        let endExclusive = selection.location + selection.length

        // forward selection: head at end-1 (inclusive)
        if start == anchor {
            let headOffset = max(start, endExclusive - 1)
            return Self.position(for: headOffset, in: lines)
        }

        // backward selection: head at start
        return Self.position(for: start, in: lines)
    }

    // MARK: - Cursor / text access

    func cursorOffset() -> Int {
        selection.location
    }

    func getCursorPosition() -> NSRange? {
        selection
    }

    func cursorPosition() -> Position {
        Self.position(for: selection.location, in: lines)
    }

    func lineCount() -> Int {
        lines.count
    }

    func line(at index: Int) -> String {
        guard index >= 0, index < lines.count else { return "" }
        return lines[index]
    }

    func char(at pos: Position) -> Character? {
        guard pos.line >= 0, pos.line < lines.count else { return nil }
        let line = lines[pos.line]
        guard pos.column >= 0, pos.column < line.count else { return nil }

        let idx = line.index(line.startIndex, offsetBy: pos.column)
        return line[idx]
    }

    func moveTo(position: Position) {
        let offset = Self.offset(for: position, in: lines)
        selection = NSRange(location: offset, length: 0)
    }

    // MARK: - Movement helpers (for your Vim-ish stuff)

    func moveLeft() {
        guard selection.location > 0 else { return }
        selection.location -= 1
        selection.length = 0
    }

    func moveRight() {
        let maxOffset = Self.totalLength(of: lines)
        guard selection.location < maxOffset else { return }
        selection.location += 1
        selection.length = 0
    }

    func moveToEndOfLine() {
        var pos = cursorPosition()
        guard pos.line < lines.count else { return }
        pos.column = lines[pos.line].count
        moveTo(position: pos)
    }

    func moveToBottomOfFile() {
        guard let lastIndex = lines.indices.last else { return }
        let col = lines[lastIndex].count
        moveTo(position: Position(line: lastIndex, column: col))
    }

    func moveToTopOfFile() {
        moveTo(position: Position(line: 0, column: 0))
    }

    func moveDownAndStartOfLine() {
        let pos = cursorPosition()
        let newLine = pos.line + 1
        guard newLine < lines.count else { return }
        moveTo(position: Position(line: newLine, column: 0))
    }

    // MARK: - Flattening helpers (mirror NSTextView-style offsets)

    private static func offset(for pos: Position, in lines: [String]) -> Int {
        var offset = 0
        for i in 0..<pos.line {
            offset += lines[i].count + 1 // +1 for "\n"
        }
        offset += pos.column
        return offset
    }

    private static func position(for offset: Int, in lines: [String]) -> Position {
        var remaining = offset
        for (lineIndex, line) in lines.enumerated() {
            let lineLen = line.count
            // caret slot inside this line (allow column == lineLen)
            if remaining <= lineLen {
                return Position(line: lineIndex, column: remaining)
            }
            // skip this line + newline
            remaining -= (lineLen + 1)
        }

        // clamp to end of last line
        if let last = lines.indices.last {
            return Position(line: last, column: lines[last].count)
        }
        return Position(line: 0, column: 0)
    }

    private static func totalLength(of lines: [String]) -> Int {
        guard !lines.isEmpty else { return 0 }
        let chars = lines.reduce(0) { $0 + $1.count }
        let newlines = lines.count - 1
        return chars + newlines
    }
}

