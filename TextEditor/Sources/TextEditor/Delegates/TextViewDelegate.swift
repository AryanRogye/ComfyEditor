//
//  TextViewDelegate.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//
import Combine
import AppKit

final class TextViewDelegate: NSObject, NSTextViewDelegate, ObservableObject {
    
    @Published var range: NSRange?
    @Published var font: NSFont?
    
    
    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        
        let range : NSRange = textView.selectedRange
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
    
    func extractSelectedText(_ textView: NSTextView, range: NSRange) {
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
