//
//  LeftOne.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/9/25.
//

import Testing
@testable import TextEditor

extension TextEditorTests {
    @Test
    func movesLeft() {
        var cursor = Position(line: 0, column: 4)
        let buffer = FakeBuffer(
            lines: [
                "TESTING",
            ],
            cursor: cursor
        )
        #expect(buffer.cursorPosition() == cursor)
        
        let vimEngine = VimEngine(buffer: buffer)
        
        /// Spamming this shit
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        cursor.column = 0
        
        let newCursorPos = buffer.cursorPosition()
        #expect(newCursorPos == cursor)
    }
    
    @Test
    func movesLeftNewline() {
        let cursor = Position(line: 1, column: 0)
        let buffer = FakeBuffer(
            lines: [
                "TESTING",
                "",
            ],
            cursor: cursor
        )
        #expect(buffer.cursorPosition() == cursor)
        
        let vimEngine = VimEngine(buffer: buffer)
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        vimEngine.handleVimEvent(Util.makeKeyEvent("h"))
        
        let newCursorPos = buffer.cursorPosition()
        #expect(newCursorPos == cursor)
    }
    
    @Test
    func movesLeftOnEmptyLineStaysPut() {
        let buffer = FakeBuffer(
            lines: [""],
            cursor: Position(line: 0, column: 0)
        )
        
        let vim = VimEngine(buffer: buffer)
        vim.handleVimEvent(Util.makeKeyEvent("h"))
        vim.handleVimEvent(Util.makeKeyEvent("h"))
        
        #expect(buffer.cursorPosition() == Position(line: 0, column: 0))
    }

}
