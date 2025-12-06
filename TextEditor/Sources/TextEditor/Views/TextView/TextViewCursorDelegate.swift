//
//  TextViewCursorDelegate.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit

@MainActor
protocol TextViewCursorDelegate: AnyObject {
    var isOnNewline: Bool { get }
    func textViewDidChangeSelection(_ notification: Notification)
}
