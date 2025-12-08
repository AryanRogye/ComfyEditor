//
//  ComfyTextView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import LocalShortcuts

final class ComfyTextView: NSTextView {
    
    struct InsertionPoint {
        let rect: NSRect
        let color: NSColor
    }
    
    override var insertionPointColor: NSColor? {
        get { .controlAccentColor }
        set { /* ignore external changes */  }
    }
    
    var vimEngine: VimEngine
    
    var originalInsertionPoint: InsertionPoint?
    var lastShortcut: LocalShortcuts.Shortcut?
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        // If the blink cycle is off, don't draw anything
        guard flag else { return }
        
        /// if User is not using vim mode then draw regular
        if !vimEngine.isInVimMode {
            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
            return
        }
        
        /// if in VimMode and we're in insert, then just draw the regular cursor
        if vimEngine.state == .insert {
            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
            return
        }
        handleVimInsertionPoint(rect, color)
    }
    
    override func keyDown(with event: NSEvent) {
        if vimEngine.isInVimMode {
            if handleVimEvent(event) {
                /// if vimEvent is ok to type then we can type
                super.keyDown(with: event)
            }
            return
        }
        super.keyDown(with: event)
    }
    
    init(vimEngine: VimEngine) {
        
        self.vimEngine = vimEngine
        
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        
        let textContainer = NSTextContainer()
        
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = false
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        super.init(frame: .zero, textContainer: textContainer)
        self.vimEngine.fsmEngine.nsTextViewBuffer.textView = self

        isVerticallyResizable = true
        isHorizontallyResizable = false
        autoresizingMask = [.width]
        
        maxSize = NSSize(
            width: CoreFoundation.CGFloat.greatestFiniteMagnitude,
            height: CoreFoundation.CGFloat.greatestFiniteMagnitude
        )
        
        isEditable = true
        isSelectable = true
        isRichText = true
        allowsDocumentBackgroundColorChange = true
        usesFontPanel = true
        usesRuler = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
