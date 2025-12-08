//
//  FSMEngine+calcNextWordTrailingDistance.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/8/25.
//

extension FSMEngine {
    internal static func calcNextWordTrailingDistance(states: [ClassifierChar], idx: Int) -> Int? {
        /// Ensure we are not already at the very end
        guard !states.isEmpty,
              idx >= 0,
              idx < states.count - 1 else {
            return nil
        }
        
        var count = 1 // 'e' always moves at least 1 character forward
        
        /// Phase 1: Skip Whitespace
        /// If we are on whitespace (or moved onto it), keep going until we hit a Word, Symbol, or Newline
        while idx + count < states.count {
            if states[idx + count] == .space {
                count += 1
            } else {
                break
            }
        }
        
        /// Check bounds after skipping space
        if idx + count >= states.count {
            return count - 1
        }
        
        /// Phase 2: Find the End of the current block
        /// We are now on the first character of the target word/symbol.
        /// We advance as long as the *next* character matches this type.
        let targetType = states[idx + count]
        
        // Treat newline as a single-char block (optional, depends on your newline preference)
        if targetType == .newline {
            return count
        }
        
        while idx + count + 1 < states.count {
            let nextType = states[idx + count + 1]
            
            if nextType == targetType {
                count += 1
            } else {
                break
            }
        }
        
        return count
    }
}
