//
//  CursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit
import Combine

@MainActor
final class CursorDelegate: NSObject, TextViewCursorDelegate, ObservableObject {
    
    @Published var charUnderCursor: Character?
    @Published var isOnNewline: Bool = false
    
    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        
        let range : NSRange = textView.selectedRange
        updateCharUnderCursor(textView, range: range)
    }
    
    /// Function is useful for many reasons:
    ///   - Determine what character is under the caret
    ///   - Resolved a bug, with the insertion point
    ///     - if the insertion point is at a \n, it would draw the insertion point all
    ///       the way to the end of the document, instead of the block of newline
    ///     - we now keep a flag isOnNewline to help with that
    private func updateCharUnderCursor(
        _ textView: NSTextView,
        range: NSRange
    ) {
        let string = textView.string
        let utf16Count = string.utf16.count
        
        guard utf16Count > 0 else {
            reset()
            return
        }
        guard range.location < utf16Count else {
            reset()
            return
        }
        
        /// Get Index by getting the start ----> offsetting by caret
        let idx = String.Index(utf16Offset: range.location, in: string)
        /// Get Character at Index from above
        let ch : Character = string[idx]
        
        charUnderCursor = ch
        isOnNewline = ch == "\n"
    }
    
    private func reset() {
        charUnderCursor = nil
        isOnNewline = false
    }
}
