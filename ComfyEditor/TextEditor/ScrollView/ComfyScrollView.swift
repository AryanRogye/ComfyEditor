//
//  ComfyScrollView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit

final class ComfyScrollView: NSScrollView {
    weak var magnificationDelegate: ScrollViewMagnificationDelegate?
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        allowsMagnification = true
        magnification = 4.0
        minMagnification = 0.5
        maxMagnification = 6.0
    }
    
    func setZoom(_ value: CGFloat) {
        let clamped = max(minMagnification, min(value, maxMagnification))
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        
        super.setMagnification(clamped, centeredAt: center)
        magnificationDelegate?.scrollView(self, didChangeMagnification: clamped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func magnify(with event: NSEvent) {
        super.magnify(with: event)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
    override func setMagnification(_ magnification: CGFloat, centeredAt point: NSPoint) {
        super.setMagnification(magnification, centeredAt: point)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
    override func smartMagnify(with event: NSEvent) {
        super.smartMagnify(with: event)
        magnificationDelegate?.scrollView(self, didChangeMagnification: magnification)
    }
}
