import Testing
@testable import TextEditor

@MainActor
final class TextEditorTests {

    @Test
    func sampleTest() {
        #expect(1 + 1 == 2)
    }

    @Test
    func testBasicMoveUp() {
        let buffer = FakeBuffer(
            lines: [
                "First line",
                "Second line",
                "Third line"
            ],
            cursor: Position(line: 2, column: 0)
        )
        
        
        var newCursorPos = buffer.cursorPosition()
        print(newCursorPos)
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.handleVimEvent(Util.makeKeyEvent("k"))
        
        newCursorPos = buffer.cursorPosition()
        print(newCursorPos)
        
        #expect(newCursorPos.line == 1)
        #expect(newCursorPos.column == 0)
    }
    
    @Test
    func testMoveUpClampsToShorterLine() {
        // Scenario: Moving from long line -> short line
        let buffer = FakeBuffer(
            lines: ["Short", "Longer line"],
            cursor: Position(line: 1, column: 10) // End of "Longer line"
        )
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.handleVimEvent(Util.makeKeyEvent("k"))
        
        let newCursor = buffer.cursorPosition()
        
        // Should clamp to end of "Short" (index 4)
        #expect(newCursor.line == 0)
        #expect(newCursor.column == 4)
    }
    
    @Test
    func testMoveUpPreservesColumn() {
        // Scenario: Moving from short line -> long line (or equal)
        let buffer = FakeBuffer(
            lines: ["Longer line", "Short"],
            cursor: Position(line: 1, column: 2) // Middle of "Short"
        )
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.handleVimEvent(Util.makeKeyEvent("k"))
        
        let newCursor = buffer.cursorPosition()
        
        // Should stay at column 2
        #expect(newCursor.line == 0)
        #expect(newCursor.column == 2)
    }
}
