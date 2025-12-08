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
    
    var cancellables: Set<AnyCancellable> = []
    
    init(vimEngine: VimEngine) {
        self.vimEngine = vimEngine
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        layer?.borderColor = NSColor(.gray.opacity(0.3)).cgColor
        layer?.borderWidth = 1
        setup()
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
    }
}
