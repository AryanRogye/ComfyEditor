//
//  MotionEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension FSMEngine {
    @MainActor
    final class MotionEngine {
        public init(buffer: BufferView) { self.buffer = buffer }
        var buffer: BufferView
        
        func lastWordLeading() {
            guard let textView = buffer.getTextView() else { return }
            var currentPos : Position = buffer.cursorPosition()
            
            if currentPos.column == 0 {
                textView.moveLeft()
            }
            currentPos = buffer.cursorPosition()
            let line       : String   = buffer.line(at: currentPos.line)
            let classified: [ClassifierChar] = ClassifierChar.line(line)

            if let dist = calcLastWordDistanceLeading(states: classified, idx: currentPos.column) {
                textView.moveLeft(count: dist)
            }
        }
        
        func nextWordLeading() {
            guard let textView = buffer.getTextView() else { return }
            var currentPos : Position = buffer.cursorPosition()
            let line       : String   = buffer.line(at: currentPos.line)
            
            let classified: [ClassifierChar] = ClassifierChar.line(line)
            if let dist = FSMEngine.calcNextWordLeadingDistance(states: classified, idx: currentPos.column), dist != 0 {
                textView.moveRight(count: dist)
            } else {
                textView.moveRight(count: 1)
            }
            
            /// IF IS NEWLINE go 1 more forward
            if let c = buffer.char(at: buffer.cursorPosition()) {
                if ClassifierChar.init(from: c) == .newline {
                    textView.moveRight(count: 1)
                }
            }
        }
    }
}
