//
//  TextViewDelegate.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Combine
import SwiftUI

@MainActor
final class TextViewDelegate: NSObject, NSTextViewDelegate, ObservableObject {

    @Published var range: NSRange?
    @Published var font: NSFont?

    weak var vimEngine: VimEngine?
    
    var text: Binding<String> = .constant("")
    
    public func observeTextChange(_ val: Binding<String>) {
        self.text = val
    }
    
    public func textDidChange(_ notification: Notification) {
        guard let tv = notification.object as? NSTextView else { return }
        print("Called")
        // write AppKit -> SwiftUI
        if text.wrappedValue != tv.string {
            text.wrappedValue = tv.string
        }
    }
    
    public func refresh(_ textView: NSTextView) {
        calculateRange(textView)
    }

    func textView(
        _ textView: NSTextView, clickedOn cell: any NSTextAttachmentCellProtocol,
        in cellFrame: NSRect, at charIndex: Int
    ) {
        calculateRange(textView)
        guard let vimEngine else { return }
        vimEngine.updatePosition()
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        calculateRange(textView)
        guard let vimEngine else { return }
        vimEngine.updatePosition()
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
