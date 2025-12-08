//
//  FSMEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import Foundation
import AppKit

@Observable @MainActor
public final class FSMEngine {
    
    public let nsTextViewBuffer = NSTextViewBufferAdapter()
    private var motionEngine : MotionEngine?
    
    public init() {
        self.motionEngine = MotionEngine(buffer: nsTextViewBuffer)
    }
    
    public func handleLastWordLeading() {
        motionEngine?.lastWordLeading()
    }
    
    public func handleNextWordTrailing() {
        motionEngine?.nextWordTrailing()
    }
    
    public func handleNextWordLeading() {
        motionEngine?.nextWordLeading()
    }
}
