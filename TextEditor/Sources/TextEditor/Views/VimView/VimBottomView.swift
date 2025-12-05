//
//  VimBottomView.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit

final class VimBottomView: NSView {
    
    let vimText = NSTextField(labelWithString: "Vim Mode Not Enabled")
    let defaultText: String = "Vim Mode Not Enabled"
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        layer?.borderColor = .black
        layer?.borderWidth = 1
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with text: String) {
        vimText.stringValue = text
    }
    
    private func setup() {
        vimText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vimText)
        
        NSLayoutConstraint.activate([
            vimText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            vimText.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
