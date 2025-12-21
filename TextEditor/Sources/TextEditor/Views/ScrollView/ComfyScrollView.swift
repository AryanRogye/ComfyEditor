//
//  ComfyScrollView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit

final class RedrawClipView: NSClipView {
    override func scroll(to newOrigin: NSPoint) {
        super.scroll(to: newOrigin)
        documentView?.setNeedsDisplay(documentVisibleRect) // force redraw
    }
    
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        let r = super.constrainBoundsRect(proposedBounds)
        documentView?.setNeedsDisplay(r)
        return r
    }
}

final class ComfyScrollView: NSScrollView {
    weak var magnificationDelegate: ScrollViewMagnificationDelegate?
    
    init() {
        super.init(frame: .zero)
        
        hasVerticalScroller = true
        hasHorizontalScroller = true
        autohidesScrollers = true
        
        hasVerticalRuler = false
        hasHorizontalRuler = false
        rulersVisible = false
        
        translatesAutoresizingMaskIntoConstraints = false
        allowsMagnification = true
        magnification = 4.0
        minMagnification = 0.5
        maxMagnification = 6.0
        backgroundColor = .clear
    }
    
    func setZoom(_ value: CGFloat, centeredAt: NSPoint? = nil) {
        let clamped = max(minMagnification, min(value, maxMagnification))
        
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        super.setMagnification(clamped, centeredAt: centeredAt ?? center)

        magnificationDelegate?.scrollView(self, didChangeMagnification: clamped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func magnify(with event: NSEvent) {
        let pointInView = convert(event.locationInWindow, from: nil)
        
        let target = magnification + event.magnification
        setZoom(target, centeredAt: pointInView)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
    
    override func setMagnification(_ magnification: CGFloat, centeredAt point: NSPoint) {
        setZoom(magnification, centeredAt: point)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
    
    override func smartMagnify(with event: NSEvent) {
        let pointInView = convert(event.locationInWindow, from: nil)
        
        let target = magnification + event.magnification
        setZoom(target, centeredAt: pointInView)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
}
