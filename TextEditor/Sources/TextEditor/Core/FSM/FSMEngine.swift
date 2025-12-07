//
//  FSMEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/7/25.
//

import Foundation

@Observable @MainActor
public final class FSMEngine {

    public init() {}

    public var states: [FSMCharacter] = []
    public var chars: [Character] = []
    public var nextWordLength: Int?
    public var lastWordLength: Int?

    public var isOnStartOfLine: Bool = false

    /// Easy way to check if we are on a new line
    public var isOnNewLine: Bool {
        if states.count > 1 {
            return false
        }
        return states.first == .newline
    }

    public func processLine(_ line: String, _ idx: Int?) {
        states = []
        chars = []
        for char in line {
            states.append(FSMCharacter(from: char))
            chars.append(char)
        }
        if let idx {
            isOnStartOfLine = idx == 0
            calcNextWordDistance(idx: idx)
            calcLastWordDistance(idx: idx)
        }
    }

    private func calcLastWordDistance(idx: Int) {
        if states.isEmpty { return }

        var i = idx - 1

        /// 1. Skip Whitespace/Newlines backwards
        /// If we are at the start of a word (or on whitespace), this takes us to the end of the previous word.
        while i >= 0 {
            if states[i] == .space || states[i] == .newline {
                i -= 1
            } else {
                break
            }
        }

        /// If we hit start of file, we are done
        if i < 0 {
            self.lastWordLength = idx
            return
        }

        /// 2. Consume the Word/Symbol backwards
        /// We are now on the last character of the previous word (or current word if we were in the middle).
        /// We scan back until the type changes.
        let targetType = states[i]
        while i >= 0 {
            if states[i] == targetType {
                i -= 1
            } else {
                break
            }
        }

        /// i is now at the character *before* the word start (or -1)
        /// Word start is i + 1
        /// Distance to move = idx - (i + 1)
        self.lastWordLength = idx - (i + 1)
    }

    private func calcNextWordDistance(idx: Int) {
        /// if empty no word next so return
        if states.isEmpty {
            return
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

        self.nextWordLength = count
    }

    private func debugPrint(idx: Int?) {
        print("=====================================")
        print("Start Time: \(Date())")
        print("States: \(states.count)")

        var count = 0
        for state in states {
            if let idx, count == idx {
                print("[CURSOR]", terminator: "")
            } else {
                print(state.smallLabel(), terminator: "")
            }
            print(" -> ", terminator: "")
            count += 1
        }
        print("end")
        print("=====================================")
    }
}
