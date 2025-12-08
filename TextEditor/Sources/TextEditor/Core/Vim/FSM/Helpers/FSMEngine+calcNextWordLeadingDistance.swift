//
//  FSMEngine+calcNextWordDistance.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension FSMEngine {
    internal static func calcNextWordLeadingDistance(states: [ClassifierChar], idx: Int) -> Int? {
        /// if empty no word next so return
        guard !states.isEmpty,
              idx >= 0,
              idx < states.count else {
            return nil
        }
        var count = 0
        let startType = states[idx]
        
        /// Phase 1: Consume the "current word"
        /// We keep going as long as the type matches what we started with.
        /// - If we started on a Word, we consume Words.
        /// - If we started on a Symbol, we consume Symbols (this handles // naturally).
        /// - If we started on Space, we skip this phase (count stays 0).
        if startType != .space && startType != .newline {
            while idx + count < states.count {
                let index = idx + count
                let currentType = states[index]
                
                /// Stop if we hit a different type (e.g. Word -> Symbol, or Symbol -> Space)
                if currentType != startType {
                    break
                }
                count += 1
            }
        }
        
        /// Phase 2: Consume Whitespace
        /// Now that we've finished the current "block", we skip any whitespace after it.
        while idx + count < states.count {
            let index = idx + count
            if states[index] == .space {
                count += 1
            } else {
                /// Found the start of the next word (or newline)!
                break
            }
        }
        
        return count
    }
}
