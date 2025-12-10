//
//  VimEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit
import LocalShortcuts

@MainActor
class VimEngine: ObservableObject {

    /// if we are in vim or not
    @Published var isInVimMode = false
    /// What the state of vim mode we are in
    @Published var state : VimState = .normal

    @Published var position : Position?
    @Published var isOnNewLine: Bool = false

    var lastShortcut: LocalShortcuts.Shortcut?

    public let buffer : BufferView

    internal lazy var motionEngine = MotionEngine(buffer: buffer)

    @Published var visualAnchorLocation: Int?

    public func updatePosition() {
        let p = buffer.cursorPosition()
        position = p
        if let c = buffer.char(at: p) {
            isOnNewLine = c == "\n"
        }
    }

    init(buffer: BufferView = NSTextViewBufferAdapter()) {
        self.buffer = buffer
    }


    @discardableResult
    public func handleVimEvent(_ event: NSEvent) -> Bool {
        /// if not set just keep typing

        /// we can get the key from the event
        let shortcut: LocalShortcuts.Shortcut = LocalShortcuts.Shortcut.getShortcut(event: event)

        /// Shortcut holds all modifiers and keys
        /// First Check if is control c

        var didJustInsert: Bool = false
        var didJustMoveToEndOfLine: Bool = false

        switch shortcut {

            /// User Requested Normal Mode
        case Self.normal_mode:
            if state == .visual { exitVisualMode() }
            state = .normal
            /// User Requested Insert Mode
        case Self.insert_mode:
            if state == .visual { exitVisualMode() }
            state = .insert
            didJustInsert = true

        case Self.visual_mode:
            /// Handles Visual Mode Selection and flipping logic
            enterVisualMode()


        /// MOVEMENT
        case Self.move_left_one:
            if state != .insert {
                moveLeft()
            }
        case Self.move_right_one:
            if state != .insert {
                moveRight()
            }
        case Self.move_up_one:
            if state != .insert {
                moveUp()
            }
        case Self.move_down_one:
            if state != .insert {
                moveDown()
            }

        case Self.move_word_next_leading:
            if state != .insert {
                handleNextWordLeading()
            }
        case Self.move_word_next_trailing:
            if state != .insert {
                handleNextWordTrailing()
            }
        case Self.move_word_back:
            if state != .insert {
                handleLastWordLeading()
            }

        case Self.move_end_line:
            if state != .insert {
                didJustMoveToEndOfLine = true
                moveToEndOfLine()
                state = .insert
            }
        case Self.bottom_of_file:
            if state != .insert {
                moveToBottomOfFile()
            }
        case Self.g_modifier:
            if state != .insert {
                if let lastShortcut = lastShortcut {
                    let top_of_file_pattern: [LocalShortcuts.Shortcut] = [
                        lastShortcut,
                        Self.g_modifier,
                    ]
                    if top_of_file_pattern == Self.top_of_file {
                        moveToTopOfFile()
                    }
                }
            }
        default: break
        }

        lastShortcut = shortcut

        /// Update's the insertion point
        buffer.updateInsertionPoint()

        /// If In Visual Mode
        if state == .visual {
            if let range = buffer.getCursorPosition() {
                buffer.updateCursorAndSelection(anchor: visualAnchorLocation, to: range.location)
            }
        }

        if didJustInsert || didJustMoveToEndOfLine {
            return false
        }

        return state == .insert
    }

    private func enterVisualMode() {
        visualAnchorLocation = buffer.cursorOffset()
        state = .visual
    }
    private func exitVisualMode() {
        buffer.exitVisualMode()
    }
}
