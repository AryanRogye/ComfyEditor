//
//  VimMovement.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension VimEngine {
    internal func handleLastWordLeading() {
        let visualAnchorPos = buffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.lastWordLeading(visualAnchorPos)
        buffer.moveTo(position: pos)
    }
    internal func handleNextWordLeading() {
        let visualAnchorPos = buffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.nextWordLeading(visualAnchorPos)
        buffer.moveTo(position: pos)
    }
    internal func handleNextWordTrailing() {
        let visualAnchorPos = buffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos = motionEngine.nextWordTrailing(visualAnchorPos)
        buffer.moveTo(position: pos)
    }
    internal func moveLeft() {
        buffer.moveLeft()
    }
    internal func moveRight() {
        buffer.moveRight()
    }
    internal func moveUp() {
        let visualAnchorPos: Position? = buffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos: Position = motionEngine.up(visualAnchorPos)
        buffer.moveTo(position: pos)
    }

    internal func moveDown() {
        let visualAnchorPos: Position? = buffer.currentVisualHead(anchor: visualAnchorLocation)
        let pos: Position = motionEngine.down(visualAnchorPos)
        buffer.moveTo(position: pos)
    }
    internal func moveToEndOfLine() {
        buffer.moveToEndOfLine()
    }
    internal func moveToBottomOfFile() {
        buffer.moveToBottomOfFile()
    }
    internal func moveToTopOfFile() {
        buffer.moveToTopOfFile()
    }

    internal func moveDownAndStartOfLine() {
        buffer.moveDownAndStartOfLine()
    }
}
