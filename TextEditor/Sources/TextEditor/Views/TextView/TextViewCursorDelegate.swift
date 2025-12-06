//
//  TextViewCursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit

protocol TextViewCursorDelegate: AnyObject, NSTextViewDelegate {
    var isOnNewline: Bool { get }
    func textViewDidChangeSelection(_ notification: Notification)
}
