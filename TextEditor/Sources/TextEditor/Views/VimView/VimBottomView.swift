//
//  VimBottomView.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import AppKit
import Combine

final class VimBottomView: NSView {
    
    var vimEngine : VimEngine
    lazy var vimText = NSTextField(labelWithString: vimEngine.commandLine)
    
    var cancellables: Set<AnyCancellable> = []
    
    init(vimEngine: VimEngine) {
        self.vimEngine = vimEngine
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        layer?.borderColor = .black
        layer?.borderWidth = 1
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        vimText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vimText)
        
        NSLayoutConstraint.activate([
            vimText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            vimText.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}


extension VimBottomView {
    
    /// Current Flow is `isInVimMode?` -> `commandLine`
    /// Command line changes which the textView has to show back
    func observeCommandLine() {
        vimEngine.$commandLine
            .sink { [weak self] commandLine in
                guard let self else { return }
                if vimText.stringValue != commandLine {
                    vimText.stringValue = commandLine
                }
            }
            .store(in: &cancellables)
    }
}
