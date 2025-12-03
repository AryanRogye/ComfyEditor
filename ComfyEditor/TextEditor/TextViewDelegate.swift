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
    
    public func getCurrentFont(textView: NSTextView) -> NSFont {
        if let range = range, range.length > 0 {
            if let storage = textView.textStorage {
                let attrs = storage.attributes(at: range.location, effectiveRange: nil)
                return attrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            }
        }
        let currentAttrs = textView.typingAttributes
        return currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
    }
}
