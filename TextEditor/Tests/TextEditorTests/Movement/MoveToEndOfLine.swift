//
//  MoveToEndOfLine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/9/25.
//

import Testing
@testable import TextEditor

extension TextEditorTests {
    @Test
    func moveToEndOfLine_basic() {
        let line = "TESTING"
        let buffer = FakeBuffer(
            lines: [line],
            cursor: Position(line: 0, column: 0)
        )
        #expect(buffer.cursorPosition() == Position(line: 0, column: 0))
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.state = .normal
        
        vimEngine.moveToEndOfLine()
        
        let newCursor = buffer.cursorPosition()
        #expect(newCursor.line == 0)
        #expect(newCursor.column == line.count - 1)
    }
    
    @Test
    func moveToEndOfLine_fromMiddle() {
        let line = "TESTING"
        let buffer = FakeBuffer(
            lines: [line],
            cursor: Position(line: 0, column: 2) // 'S'
        )
        #expect(buffer.cursorPosition() == Position(line: 0, column: 2))
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.state = .normal
        
        vimEngine.moveToEndOfLine()
        
        let newCursor = buffer.cursorPosition()
        #expect(newCursor.line == 0)
        #expect(newCursor.column == line.count - 1)
    }
    
    @Test
    func moveToEndOfLine_onSecondLine() {
        let line1 = "FIRST"
        let line2 = "SECOND LINE"
        let buffer = FakeBuffer(
            lines: [line1, line2],
            cursor: Position(line: 1, column: 0) // start of second line
        )
        #expect(buffer.cursorPosition() == Position(line: 1, column: 0))
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.state = .normal
        
        vimEngine.moveToEndOfLine()
        
        let newCursor = buffer.cursorPosition()
        #expect(newCursor.line == 1)
        #expect(newCursor.column == line2.count - 1)
    }
    
    @Test
    func moveToEndOfLine_onEmptyLine_staysAtZero() {
        let buffer = FakeBuffer(
            lines: [""],
            cursor: Position(line: 0, column: 0)
        )
        #expect(buffer.cursorPosition() == Position(line: 0, column: 0))
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.state = .normal
        
        vimEngine.moveToEndOfLine()
        
        let newCursor = buffer.cursorPosition()
        #expect(newCursor.line == 0)
        #expect(newCursor.column == 0)
    }
    
    @Test
    func moveToEndOfLine_whenAlreadyAtEnd_noChange() {
        let line = "TESTING"
        let buffer = FakeBuffer(
            lines: [line],
            cursor: Position(line: 0, column: line.count - 1)
        )
        #expect(buffer.cursorPosition() == Position(line: 0, column: line.count - 1))
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.state = .normal
        
        vimEngine.moveToEndOfLine()
        
        let newCursor = buffer.cursorPosition()
        #expect(newCursor.line == 0)
        #expect(newCursor.column == line.count - 1)
    }
}
