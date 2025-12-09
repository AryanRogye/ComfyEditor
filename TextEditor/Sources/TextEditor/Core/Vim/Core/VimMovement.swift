//
//  VimMovement.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension VimEngine {
    internal func handleLastWordLeading() {
        let visualAnchorPos = nsTextViewBuffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.lastWordLeading(visualAnchorPos)
        nsTextViewBuffer.moveTo(position: pos)
    }
    internal func handleNextWordLeading() {
        let visualAnchorPos = nsTextViewBuffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.nextWordLeading(visualAnchorPos)
        nsTextViewBuffer.moveTo(position: pos)
    }
    internal func handleNextWordTrailing() {
        let visualAnchorPos = nsTextViewBuffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.nextWordTrailing(visualAnchorPos)
        nsTextViewBuffer.moveTo(position: pos)
    }
    internal func moveLeft() {
        nsTextViewBuffer.textView?.moveLeft(count: 1)
    }
    internal func moveRight() {
        nsTextViewBuffer.textView?.moveRight(count: 1)
    }
    internal func moveUp() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveUp(textView)
    }
    internal func moveDown() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveDown(textView)
    }
    internal func moveToEndOfLine() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToRightEndOfLine(self)
    }
    internal func moveToBottomOfFile() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToEndOfDocument(textView)
    }
    internal func moveToTopOfFile() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToBeginningOfDocument(textView)
    }
    
    /// Represents Vim-style `w` behavior across lines.
    ///
    /// Example:
    ///
    ///     something here testing o
    ///                         ^ cursor (*HERE*)
    ///     testing something out here too
    ///
    /// Pressing `w` moves the cursor to:
    ///
    ///     something here testing o
    ///     testing something out here too
    ///     ^ cursor (*HERE*)
    /// Because next word is newline, on newline, we call our function
    /// to move down and to the start of the line
    internal func moveDownAndStartOfLine() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveDown(textView)
        textView.moveToBeginningOfLine(textView)
    }
}
