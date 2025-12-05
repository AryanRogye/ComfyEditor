//
//  ComfyTextView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit

final class ComfyTextView: NSTextView {
    
    override var insertionPointColor: NSColor? {
        get { .systemRed }          // your color
        set { /* ignore external changes */ }
    }
    
    var vimEngine : VimEngine
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        
        if !vimEngine.isInVimMode {
            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
            return
        }
        
        // If the blink cycle is off, don't draw anything
        guard flag else { return }
        
        var blockRect = rect
        var charWidth: CGFloat = 8.0 // Default fallback width
        
        // 1. Calculate the width of the character under the cursor
        if let layoutManager = layoutManager, let textContainer = textContainer {
            let charIndex = self.selectedRange().location
            
            // Check if we are inside the text (not at the very end)
            if charIndex < (self.textStorage?.length ?? 0) {
                let glyphIndex = layoutManager.glyphIndexForCharacter(at: charIndex)
                let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: textContainer)
                
                // If the character has width (e.g. not a newline), use it
                if glyphRect.width > 1 {
                    charWidth = glyphRect.width
                } else {
                    // It's a newline; use the width of 'm' as a placeholder
                    charWidth = font?.pointSize ?? 12
                }
            } else {
                // End of document; use the width of 'm'
                if let font = self.font {
                    charWidth = "m".size(withAttributes: [.font: font]).width
                }
            }
        }
        
        // 2. Set the block width
        blockRect.size.width = charWidth
        
        // 3. Draw with "Exclusion" or "Difference" blend mode
        // This inverts the text color behind the cursor so it remains readable
        // while the cursor looks solid.
        NSGraphicsContext.saveGraphicsState()
        
        // Set the color (Pink block?)
        color.setFill()
        
        // This is the magic line for the "Terminal/Vim" look:
        NSGraphicsContext.current?.compositingOperation = .exclusion
        
        // Draw the block (Standard Vim is sharp corners, no roundedRect)
        NSBezierPath(rect: blockRect).fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    init(vimEngine: VimEngine) {
        
        self.vimEngine = vimEngine
        
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        
        let textContainer = NSTextContainer()
        textContainer.widthTracksTextView = true
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        super.init(frame: .zero, textContainer: textContainer)
        
        isVerticallyResizable = true
        isHorizontallyResizable = false
        autoresizingMask = [.width]

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
