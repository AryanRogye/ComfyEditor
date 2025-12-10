//
//  MotionEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import Foundation
import ComfyLogger

extension ComfyLogger.Name {
    static let MotionEngine = ComfyLogger.Name("MotionEngine")
}

@MainActor
final class MotionEngine {
    
    typealias Log = ComfyLogger.Name
    public init(buffer: BufferView) {
        self.buffer = buffer
        Log.MotionEngine.enable()
    }
    var buffer: BufferView
    var stickyColumn: Int?
    
    /// Function to go to the last word thats leading
    func lastWordLeading(_ currentPos: Position? = nil) -> Position {
        var currentPos : Position = currentPos ?? buffer.cursorPosition()
        
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
    
    func nextWordTrailing(_ currentPos: Position? = nil) -> Position {
        let currentPos : Position = currentPos ?? buffer.cursorPosition()
        let line       : String   = buffer.line(at: currentPos.line)
        
        let classified = ClassifierChar.line(line)
        
        let dist = TextEngine.calcNextWordTrailingDistance(states: classified, idx: currentPos.column)
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
    
    func nextWordLeading(_ currentPos: Position? = nil) -> Position {
        let currentPos : Position = currentPos ?? buffer.cursorPosition()
        let line       : String   = buffer.line(at: currentPos.line)
        
        let classified: [ClassifierChar] = ClassifierChar.line(line)
        
        let dist = TextEngine.calcNextWordLeadingDistance(states: classified, idx: currentPos.column)
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
    
    public func up(_ currentPos: Position? = nil) -> Position {
        var currentPos : Position = currentPos ?? buffer.cursorPosition()
        
        Log.MotionEngine.start()
        Log.MotionEngine.insert("Before Pos: \(currentPos)")

        /// we cant move here so we just return currentPos
        if currentPos.line == 0 {
            return currentPos
        }
        
        let targetLine = currentPos.line - 1
        
        if targetLine < 0 || targetLine > buffer.lineCount() {
            return currentPos
        }
        
        let column = currentPos.column
        
        /// Move back a line
        currentPos.line = targetLine
        /// Get line text
        var line = buffer.line(at: targetLine)
        
        /// Max Column of the line
        let maxCol = line.count - 1
        
        
        if column > maxCol, stickyColumn == nil {
            Log.MotionEngine.insert("Setting Sticky Column \(column)")
            stickyColumn = column
            currentPos.column = min(currentPos.column, maxCol)
        } else {
            if let stickyColumn {
                /// this means theres a value here we can go up by 1
                currentPos.column = min(stickyColumn, maxCol)
                Log.MotionEngine.insert("STICKY: \(stickyColumn)")
                Log.MotionEngine.insert("MAX-COL: \(maxCol)")
                Log.MotionEngine.insert("Applying Sticky Column or maxCol: \(min(stickyColumn, maxCol))")
                self.stickyColumn = nil
            } else {
                Log.MotionEngine.insert("Skipping Sticky Column")
                currentPos.column = min(currentPos.column, maxCol)
            }
        }
        
        line = buffer.line(at: currentPos.line)
        if let c = line.char(at: currentPos.column), c == "\n" && currentPos.column == line.count - 1 {
            Log.MotionEngine.insert("Detected a newline in the column, moving left")
            /// Move Left
            currentPos.column -= 1
        } else {
            Log.MotionEngine.insert("Chose Not to move left")
        }
        Log.MotionEngine.insert("After Pos: \(currentPos)")
        Log.MotionEngine.end()
        return currentPos
    }
    
    public func down(_ currentPos: Position? = nil) -> Position {
        var currentPos : Position = currentPos ?? buffer.cursorPosition()
        let column = currentPos.column
        
        if currentPos.line == buffer.lineCount() - 1 {
            return currentPos
        }
        let lineNumber = currentPos.line + 1
        if lineNumber < 0 || lineNumber > buffer.lineCount() {
            return currentPos
        }
        currentPos.line += 1
        let line = buffer.line(at: lineNumber)
        
        if column < line.count {
            return currentPos
        }
        
        currentPos.column = line.count - 1
        return currentPos
    }
}
