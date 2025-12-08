//
//  VimMovement.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension VimEngine {
    func handleLastWordLeading() {
        let pos = motionEngine.lastWordLeading()
        nsTextViewBuffer.moveTo(position: pos)
    }
    func handleNextWordLeading() {
        let pos = motionEngine.nextWordLeading()
        nsTextViewBuffer.moveTo(position: pos)
    }
    func handleNextWordTrailing() {
        let pos = motionEngine.nextWordTrailing()
        nsTextViewBuffer.moveTo(position: pos)
    }
    func moveLeft() {
        nsTextViewBuffer.textView?.moveLeft(count: 1)
    }
    func moveRight() {
        nsTextViewBuffer.textView?.moveRight(count: 1)
    }
    func moveUp() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveUp(textView)
    }
    func moveDown() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveDown(textView)
    }
    func moveToEndOfLine() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToRightEndOfLine(self)
    }
    func moveToBottomOfFile() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToEndOfDocument(textView)
    }
    func moveToTopOfFile() {
        guard let textView = nsTextViewBuffer.textView else { return }
        textView.moveToBeginningOfDocument(textView)
    }
}
