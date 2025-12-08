//
//  VimMovement.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension VimEngine {
    func handleLastWordLeading() {
        fsmEngine.handleLastWordLeading()
    }
    func handleNextWordLeading() {
        fsmEngine.handleNextWordLeading()
    }
    func moveLeft() {
        fsmEngine.nsTextViewBuffer.textView?.moveLeft(count: 1)
    }
    func moveRight() {
        fsmEngine.nsTextViewBuffer.textView?.moveRight(count: 1)
    }
    func moveUp() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveUp(textView)
    }
    func moveDown() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveDown(textView)
    }
    func moveToEndOfLine() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveToRightEndOfLine(self)
    }
    func moveToBottomOfFile() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveToEndOfDocument(textView)
    }
    func moveToTopOfFile() {
        guard let textView = fsmEngine.nsTextViewBuffer.textView else { return }
        textView.moveToBeginningOfDocument(textView)
    }
}
