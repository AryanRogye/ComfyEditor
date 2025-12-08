//
//  FSMengine+calcLastWordDistance.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

extension FSMEngine {
    internal func calcLastWordDistance(idx: Int) {
//        if states.isEmpty { return }
//        
//        var i = idx - 1
//        
//        /// 1. Skip Whitespace/Newlines backwards
//        /// If we are at the start of a word (or on whitespace), this takes us to the end of the previous word.
//        while i >= 0 {
//            if states[i] == .space || states[i] == .newline {
//                i -= 1
//            } else {
//                break
//            }
//        }
//        
//        /// If we hit start of file, we are done
//        if i < 0 {
//            self.lastWordStartDistance = idx
//            return
//        }
//        
//        /// 2. Consume the Word/Symbol backwards
//        /// We are now on the last character of the previous word (or current word if we were in the middle).
//        /// We scan back until the type changes.
//        let targetType = states[i]
//        while i >= 0 {
//            if states[i] == targetType {
//                i -= 1
//            } else {
//                break
//            }
//        }
//        
//        /// i is now at the character *before* the word start (or -1)
//        /// Word start is i + 1
//        /// Distance to move = idx - (i + 1)
//        self.lastWordStartDistance = idx - (i + 1)
    }
}
