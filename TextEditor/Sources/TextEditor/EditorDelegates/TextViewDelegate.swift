import AppKit
//
//  TextViewDelegate.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//
import Combine

@MainActor
final class TextViewDelegate: NSObject, NSTextViewDelegate, ObservableObject {

    @Published var range: NSRange?
    @Published var font: NSFont?

    weak var fsmEngine: FSMEngine?
    
    public func refresh(_ textView: NSTextView) {
        calculateRange(textView)
        fsmEngineProcess(textView)
    }

    func textView(
        _ textView: NSTextView, clickedOn cell: any NSTextAttachmentCellProtocol,
        in cellFrame: NSRect, at charIndex: Int
    ) {
        calculateRange(textView)
        fsmEngineProcess(textView)
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        calculateRange(textView)
        fsmEngineProcess(textView)
    }

    private func fsmEngineProcess(_ textView: NSTextView) {
        guard let fsmEngine else {
            print("FSM Engine Not Set")
            return
        }
        let (line, idx) = getLine(textView)
        if let line {
            fsmEngine.processLine(line, idx)
        }
    }

    /// Function gets the line where the caret is currently at
    private func getLine(
        _ textView: NSTextView
    ) -> (String?, Int?) {
        let range: NSRange = textView.selectedRange
        let string = textView.string
        let utf16Count = string.utf16.count

        guard utf16Count > 0, range.location < utf16Count else {
            return (nil, nil)
        }

        /// This idx is the current caret position
        let idx = String.Index(
            utf16Offset: range.location,
            in: string
        )

        /// we can go back to find the last \n
        var start = idx

        // Check if we are already at a newline or need to go back
        if start != string.startIndex && start < string.endIndex && string[start] == "\n" {
            /// Return if is a newline
            return ("\n", nil)
        }

        while start > string.startIndex {
            let prevIdx = string.index(before: start)
            if string[prevIdx] == "\n" {
                /// UnCommenting brings back the \n before the line
                //                                start = prevIdx
                break
            }
            start = prevIdx
        }

        var end = idx
        while end < string.endIndex {
            let currentChar = string[end]
            if currentChar == "\n" {
                /// Include the newline character in the line
                end = string.index(after: end)
                break
            }
            end = string.index(after: end)
        }
        let cursorInLine = string.distance(from: start, to: idx)

        return (String(string[start..<end]), cursorInLine)
    }

    private func calculateRange(_ textView: NSTextView) {
        let range: NSRange = textView.selectedRange
        let hasSelection = range.length > 0
        // Use hasSelection (e.g., update UI, enable actions, etc.)
        if hasSelection {
            /// Set range of selection here
            self.range = range
            font = getCurrentFont(textView: textView)
        } else {
            /// if nothing selected, we nullify range
            self.range = nil
            font = getCurrentFont(textView: textView)
        }
    }

    public func forceFontRefresh(textView: NSTextView) {
        font = getCurrentFont(textView: textView)
    }

    public func getCurrentFont(textView: NSTextView) -> NSFont? {

        /// if User is Selecting something, AND range > 0
        if let range = range, range.length > 0, let storage = textView.textStorage {
            var isUniform = false
            var nsFont: NSFont?

            storage.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired)
            { value, subRange, stop in
                // If the first run covers the whole range, it's all one font.
                isUniform = (subRange == range)
                nsFont = value as? NSFont

                // Stop immediately; we don't need to look further.
                stop.pointee = true
            }
            if isUniform {
                return nsFont
            } else {
                return nil
            }
        }

        /// IF nothing is selected by the user
        /// What size is under the cursor
        let currentAttrs = textView.typingAttributes
        return currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
    }
}
