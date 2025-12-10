//
//  ComfyTextView+Vim+InsertionPoint.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/6/25.
//

import AppKit

extension ComfyTextView {
//    func handleVimInsertionPoint(_ rect: NSRect, _ color: NSColor) {
//        var blockRect = rect
//        var charWidth: CGFloat = 8.0 // Default fallback width
//        
//        // 1. Calculate the width of the character under the cursor
//        if let layoutManager = layoutManager, let textContainer = textContainer, !vimEngine.isOnNewLine {
//            
//            /// Get location of the index of the character
//            let charIndex = self.selectedRange().location
//            
//            let endOfDocument = self.textStorage?.length ?? 0
//            
//            // Check if we are inside the text (not at the very end)
//            if charIndex < endOfDocument {
//                let glyphIndex = layoutManager.glyphIndexForCharacter(at: charIndex)
//                let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: textContainer)
//                
//                // If the character has width (e.g. not a newline), use it
//                if glyphRect.width > 1 {
//                    charWidth = glyphRect.width
//                } else {
//                    // It's a newline; use the width of 'm' as a placeholder
//                    charWidth = font?.pointSize ?? 12
//                }
//            }
//            else {
//                // End of document; use the width of 'm'
//                if let font = self.font {
//                    charWidth = "m".size(withAttributes: [.font: font]).width
//                }
//            }
//        }
//        
//        // 2. Set the block width
//        blockRect.size.width = charWidth
//        
//        // 3. Draw with "Exclusion" or "Difference" blend mode
//        // This inverts the text color behind the cursor so it remains readable
//        // while the cursor looks solid.
//        NSGraphicsContext.saveGraphicsState()
//        
//        // Set the color (Pink block?)
//        color.setFill()
//        
//        // This is the magic line for the "Terminal/Vim" look:
//        NSGraphicsContext.current?.compositingOperation = .exclusion
//        
//        // Draw the block (Standard Vim is sharp corners, no roundedRect)
//        NSBezierPath(rect: blockRect).fill()
//        
//        NSGraphicsContext.restoreGraphicsState()
//    }
    
    func handleVimInsertionPoint(_ rect: NSRect, _ color: NSColor) {
        var blockRect = rect
        var charWidth: CGFloat = 8.0 // Default fallback width
        
        if let layoutManager = layoutManager,
           let textContainer = textContainer
        {
            // pick which side of the selection you want as the "cursor"
            let selection = self.selectedRange()
            let logicalIndex: Int
            
            if selection.length == 0 {
                logicalIndex = selection.location
            } else {
                // active end of visual selection; flip if you prefer the other side
                logicalIndex = selection.upperBound
            }
            
            let endOfDocument = self.textStorage?.length ?? 0
            let clampedIndex = max(0, min(logicalIndex, max(endOfDocument - 1, 0)))
            
            let glyphIndex = layoutManager.glyphIndexForCharacter(at: clampedIndex)
            var glyphRect = layoutManager.boundingRect(
                forGlyphRange: NSRange(location: glyphIndex, length: 1),
                in: textContainer
            )
            
            // move from container coords → view coords
            glyphRect.origin.x += textContainerOrigin.x
            glyphRect.origin.y += textContainerOrigin.y
            
            // base rect for the block cursor
            blockRect.origin = glyphRect.origin
            blockRect.size.height = glyphRect.height
            
            // width logic
            if glyphRect.width > 1 {
                charWidth = glyphRect.width
            } else if let font = self.font {
                charWidth = "m".size(withAttributes: [.font: font]).width
            }
        }
        
        // 2. Set the block width
        blockRect.size.width = charWidth
        
        // 3. Draw with "Exclusion" or "Difference" blend mode
        NSGraphicsContext.saveGraphicsState()
        color.setFill()
        NSGraphicsContext.current?.compositingOperation = .exclusion
        NSBezierPath(rect: blockRect).fill()
        NSGraphicsContext.restoreGraphicsState()
    }
}


final class CaretOverlayView: NSView {
    var caretRect: NSRect? {
        didSet { needsDisplay = true }
    }
    
    override var isFlipped: Bool { true } // match NSTextView if needed
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let caretRect else { return }
        
        NSColor.labelColor.setFill()
        NSBezierPath(rect: caretRect).fill()
    }
}
