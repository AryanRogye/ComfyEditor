//
//  MotionEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

@MainActor
final class MotionEngine {
    public init(buffer: BufferView) { self.buffer = buffer }
    var buffer: BufferView
    
    /// Function to go to the last word thats leading
    func lastWordLeading() -> Position {
        var currentPos : Position = buffer.cursorPosition()
        
        /// Move up by 1 if at 0 index
        if currentPos.column == 0 {
            /// as long as gong back by 1 line wont crash us
            if currentPos.line > 0 {
                let lastLineIdx = currentPos.line - 1
                let lastLineStr = buffer.line(at: lastLineIdx)
                
                /// "Wrap" to the end of the previous line
                currentPos = Position(line: lastLineIdx, column: lastLineStr.count)
            }
            /// if moving back 1 line crashes us return current pos
            /// We are at 0,0 (Start of file) -> Don't move
            else {
                return currentPos
            }
        }
        
        let line       : String   = buffer.line(at: currentPos.line)
        let classified: [ClassifierChar] = ClassifierChar.line(line)
        
        if let dist = TextEngine.calcLastWordDistanceLeading(states: classified, idx: currentPos.column) {
            let newCol = currentPos.column - dist
            currentPos = Position(line: currentPos.line, column: max(0, newCol))
        }
        return currentPos
    }
    
    func nextWordTrailing() -> Position {
        var currentPos : Position = buffer.cursorPosition()
        let line       : String   = buffer.line(at: currentPos.line)
        
        let classified = ClassifierChar.line(line)
        
        var dist = TextEngine.calcNextWordTrailingDistance(states: classified, idx: currentPos.column)
        var count = 1;
        if let dist, dist != 0 {
            count = dist
        }
        let newCol = currentPos.column + count
        if newCol >= line.count {
            return Position(line: currentPos.line + 1, column: 0)
        }
        return Position(line: currentPos.line, column: (max(0, newCol)))
    }
    
    func nextWordLeading() -> Position {
        var currentPos : Position = buffer.cursorPosition()
        let line       : String   = buffer.line(at: currentPos.line)
        
        let classified: [ClassifierChar] = ClassifierChar.line(line)
        
        var dist = TextEngine.calcNextWordLeadingDistance(states: classified, idx: currentPos.column)
        var count = 1;
        if let dist, dist != 0 {
            count = dist
        }
        var newCol = currentPos.column + count

        /// IF IS NEWLINE go 1 more forward
        if let c = buffer.char(at: currentPos) {
            if ClassifierChar.init(from: c) == .newline {
                newCol += 1
            }
        }
        if newCol >= line.count {
            return Position(line: currentPos.line + 1, column: 0)
        }
        return Position(line: currentPos.line, column: (max(0, newCol)))
    }
}
