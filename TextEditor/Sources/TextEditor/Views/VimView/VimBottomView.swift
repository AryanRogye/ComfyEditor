//
//  VimBottomView.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit
import SwiftUI
import Combine

final class VimBottomView: NSView {
    
    var vimEngine : VimEngine
    
    private let topBorder = CALayer()
    private var borderThickness: CGFloat = 1

    init(vimEngine: VimEngine) {
        self.vimEngine = vimEngine
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        setup()
    }
    
    override func layout() {
        super.layout()
        topBorder.frame = CGRect(
            x: 0,
            y: bounds.height - borderThickness,
            width: bounds.width,
            height: borderThickness
        )
    }
    
    public func setBorderColor(color: NSColor) {
        wantsLayer = true
        topBorder.backgroundColor = color.cgColor
        needsLayout = true
    }
    
    public func setBackground(color: NSColor) {
        layer?.backgroundColor = color.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        let hosting = NSHostingView(rootView: VimStatus(
            vimEngine: vimEngine
        ))
        hosting.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hosting)
        
        NSLayoutConstraint.activate([
            hosting.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hosting.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hosting.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        layer?.addSublayer(topBorder)
    }
}
