//
//  VimEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import Foundation

@MainActor
class VimEngine: ObservableObject {
    
    /// if we are in vim or not
    @Published var isInVimMode = false
    /// What the state of vim mode we are in
    @Published var state : VimState = .normal
    
    @Published var position : FSMEngine.Position?
    
    /// Engine Powering the Movement Logic
    let fsmEngine = FSMEngine()
    
    public func updatePosition() {
        position = fsmEngine.nsTextViewBuffer.cursorPosition()
    }

    init() {
    }
    
    func handleNextWord() {
        fsmEngine.handleNextWordLeading()
    }
}
