//
//  CursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit
import Combine

final class CursorDelegate: NSObject, TextViewCursorDelegate, ObservableObject {
    @Published var range: NSRange?
    @Published var font: NSFont?
    @Published var wordUnderCursor: String?
    @Published var charUnderCursor: String?
    @Published var isOnNewline: Bool = false
    
    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        
        let range : NSRange = textView.selectedRange
        updateCharUnderCursor(textView, range: range)
        let hasSelection = range.length > 0
        // Use hasSelection (e.g., update UI, enable actions, etc.)
        if hasSelection {
            extractSelectedText(textView, range: range)
            font = getCurrentFont(textView: textView)
        } else {
            self.range = nil
            font = getCurrentFont(textView: textView)
        }
    }
    
    private func updateCharUnderCursor(_ textView: NSTextView, range: NSRange) {
        let ns = textView.string as NSString
        
        guard ns.length > 0 else {
            charUnderCursor = nil
            isOnNewline = false
            return
        }
        
        let caret = min(range.location, max(ns.length - 1, 0))
        
        guard ns.length > 0 else {
            charUnderCursor = nil
            return
        }
        
        let uni = ns.character(at: caret)
        charUnderCursor = String(UnicodeScalar(uni)!)
        isOnNewline = (charUnderCursor == "\n")
    }
    
    private func extractSelectedText(_ textView: NSTextView, range: NSRange) {
        self.range = range
    }
    
    public func forceFontRefresh(textView: NSTextView) {
        font = getCurrentFont(textView: textView)
    }
    
    public func getCurrentFont(textView: NSTextView) -> NSFont? {
        
        /// if User is Selecting something, AND range > 0
        if let range = range, range.length > 0, let storage = textView.textStorage {
            var isUniform = false
            var nsFont: NSFont?
            
            storage.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { value, subRange, stop in
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
        
        /// What size is under the cursor
        let currentAttrs = textView.typingAttributes
        return currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
    }
    
}
