//
//  CursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit
import Combine

final class CursorDelegate: NSObject, TextViewCursorDelegate, ObservableObject {
    
    @Published var charUnderCursor: String?
    @Published var isOnNewline: Bool = false
    
    func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        
        let range : NSRange = textView.selectedRange
        updateCharUnderCursor(textView, range: range)
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
}
