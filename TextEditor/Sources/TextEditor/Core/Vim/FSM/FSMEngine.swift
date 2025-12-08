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
    
    public var nextWordStartDistance: Int?
    public var lastWordStartDistance: Int?
    
    public var isOnStartOfLine: Bool = false
    
    /// Easy way to check if we are on a new line
    public var isOnNewLine: Bool {
        false
    }
    
    public func handleNextWordLeading() {
        motionEngine?.nextWordLeading()
    }
}
