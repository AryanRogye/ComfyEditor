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
        
        func nextWordLeading() {
            guard let textView = buffer.getTextView() else { return }
            let currentPos : Position = buffer.cursorPosition()
            let line       : String   = buffer.line(at: currentPos.line)
            
            let classified: [ClassifierChar] = ClassifierChar.line(line)
            if let dist = FSMEngine.calcNextWordLeadingDistance(states: classified, idx: currentPos.column), dist != 0 {
                textView.moveRight(count: dist)
            } else {
                textView.moveRight(count: 1)
            }
            /// TODO CHECK IF IS NEWLINE, if it is then that should be a newline
        }
    }
}
