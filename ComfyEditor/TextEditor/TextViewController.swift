//
//  TextViewController.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Combine

class TextViewController: NSViewController {
    
    let fontManager = NSFontManager.shared
    
    let scrollView = NSScrollView()
    let textView = NSTextView()
    
    let textViewDelegate = EditorCommandCenter.shared.textViewDelegate
    
    var isAppActive: Bool { NSApplication.shared.isActive }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        EditorCommandCenter.shared.currentEditor = self
    }
    
    override func loadView() {
        let root = NSView()
        self.view = root
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.allowsMagnification = true
        scrollView.minMagnification = 0.5
        scrollView.maxMagnification = 4.0
        
        textView.isEditable = true
        textView.isSelectable = true
        textView.isRichText = true
        textView.delegate = textViewDelegate
        textView.allowsDocumentBackgroundColorChange = true
        textView.usesFontPanel = true
        textView.usesRuler = true
        
        scrollView.documentView = textView
        root.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: root.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: root.bottomAnchor)
        ])
    }
}

// MARK: - Bold
extension TextViewController {
    
    /// Bold information that is returned
    typealias BoldFontInfo = (Bool, [NSAttributedString.Key : Any], NSFont)
    
    /// Public Function to toggle bold
    /// Could be on selection OR entire editor
    ///     Currently set to 1 or the other
    ///     TODO: Maybe have a "Bold on Selection, Configures"
    public func toggleBold() {
        guard isAppActive else { return }
        
        /// See if TextView is currently selected or not
        if let range = textViewDelegate.range {
            guard let storage = textView.textStorage else { return }
            let (isBold, _, currentFont) = isCurrentlyBold(range, in: storage)
            
            let newFont = isBold
            ? fontManager.convert(currentFont, toNotHaveTrait: .boldFontMask)
            : fontManager.convert(currentFont, toHaveTrait: .boldFontMask)
            
            storage.addAttribute(.font, value: newFont, range: range)
            
            /// false because we did not "set" bold
            return
        } else {
            let (isBold, currentAttrs, currentFont) = isCurrentlyBold()
            let newFont = isBold
            ? fontManager.convert(currentFont, toNotHaveTrait: .boldFontMask)
            : fontManager.convert(currentFont, toHaveTrait: .boldFontMask)
            
            var newAttrs = currentAttrs
            newAttrs[.font] = newFont
            textView.typingAttributes = newAttrs
            
            return
        }
    }
    
    internal func isCurrentlyBold(_ range: NSRange, in storage: NSTextStorage) -> BoldFontInfo {
        let attrs = storage.attributes(at: range.location, effectiveRange: nil)
        let currentFont = attrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return (fontManager.traits(of: currentFont).contains(.boldFontMask), attrs, currentFont)
    }
    internal func isCurrentlyBold() -> BoldFontInfo {
        let currentAttrs = textView.typingAttributes
        let currentFont = currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return (fontManager.traits(of: currentFont).contains(.boldFontMask), currentAttrs, currentFont)
    }
    public func isCurrentlyBold() -> Bool {
        let currentAttrs = textView.typingAttributes
        let currentFont = currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return fontManager.traits(of: currentFont).contains(.boldFontMask)
    }
}


// MARK: - Increase / Decrease Font
extension TextViewController {
    
    public func increaseFontOrZoomIn() {
        guard isAppActive else { return }

        if let range = textViewDelegate.range, range.length > 0 {
            guard let storage = textView.textStorage else { return }
            updateFont(range, storage: storage, increase: true)
            textViewDelegate.forceFontRefresh(textView: textView)
        } else {
            scrollView.magnification = min(
                scrollView.magnification + 0.1,
                scrollView.maxMagnification
            )
        }
    }
    
    public func decreaseFontOrZoomOut() {
        guard isAppActive else { return }

        if let range = textViewDelegate.range, range.length > 0 {
            guard let storage = textView.textStorage else { return }
            updateFont(range, storage: storage, increase: false)
            textViewDelegate.forceFontRefresh(textView: textView)
        } else {
            scrollView.magnification = max(
                scrollView.magnification - 0.1,
                scrollView.minMagnification
            )
        }
    }
    
    internal func updateFont(_ range: NSRange, storage: NSTextStorage, increase: Bool) {
        storage.enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
            guard let font = value as? NSFont else { return }
            
            let delta: CGFloat = increase ? 1.0 : -1.0
            let newSize = max(1, font.pointSize + delta)
            
            let newFont = fontManager.convert(font, toSize: newSize)
            storage.addAttribute(.font, value: newFont, range: subRange)
        }
    }
}
