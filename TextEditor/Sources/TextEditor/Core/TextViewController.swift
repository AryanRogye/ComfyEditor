//
//  TextViewController.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Combine

public class TextViewController: NSViewController {
    
    /// macOS Given font manager
    let fontManager = NSFontManager.shared
    
    let vimEngine = VimEngine()
    
    // MARK: - View's
    /// Our Implementation of a NSScrollView
    /// Lets us hook into `new delegates`
    let scrollView = ComfyScrollView()
    /// Our Implementation of a NSTextView
    lazy var textView = ComfyTextView(vimEngine: vimEngine)
    
    /// Bottom Bar for Vim Command Input, etc
    lazy var vimBottomView = VimBottomView(vimEngine: vimEngine)
    
    // MARK: - Delegates
    /// Text Delegate
    let textDelegate = EditorCommandCenter.shared.textViewDelegate
    let cursorDelegate = EditorCommandCenter.shared.cursorDelegate
    /// Magnification Delegate
    let magnificationDelegate = EditorCommandCenter.shared.magnificationDelegate
    
    /// Flag to know if the app is focussed or not
    internal var isAppActive: Bool {
        NSApplication.shared.isActive
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear() {
        super.viewDidAppear()
        EditorCommandCenter.shared.currentEditor = self
        
        /// Helps when the text editor is brought back into view
        /// for some reason if the request is:
        ///     NavigationLink -> NSViewControllerRepresentable -> NSViewController
        ///     without the following, nothing would show
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view.window?.makeFirstResponder(self.textView)
        }
    }
    
    // MARK: - Load View
    public override func loadView() {
        let root = NSView()
        root.wantsLayer = true
        self.view = root
        
        /// Assign ScrollView Delegate
        scrollView.magnificationDelegate = magnificationDelegate
        
        /// Assign TextView delegate's
        textView.cursorDelegate = cursorDelegate
        textView.delegate = textDelegate
        
        scrollView.documentView = textView
        root.addSubview(scrollView)
        root.addSubview(vimBottomView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: root.topAnchor),
            // instead of pinning scroll bottom to root:
            scrollView.bottomAnchor.constraint(equalTo: vimBottomView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            vimBottomView.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            vimBottomView.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            vimBottomView.bottomAnchor.constraint(equalTo: root.bottomAnchor),
            vimBottomView.heightAnchor.constraint(equalToConstant: 24)
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
        if let range = textDelegate.range {
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
    
    /// Internal function to get if is bold under a range
    internal func isCurrentlyBold(_ range: NSRange, in storage: NSTextStorage) -> BoldFontInfo {
        let attrs = storage.attributes(at: range.location, effectiveRange: nil)
        let currentFont = attrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return (fontManager.traits(of: currentFont).contains(.boldFontMask), attrs, currentFont)
    }
    /// Internal function to get if is bold in general
    /// Returns `(Bool, [NSAttributedString.Key : Any], NSFont)`
    internal func isCurrentlyBold() -> BoldFontInfo {
        let currentAttrs = textView.typingAttributes
        let currentFont = currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return (fontManager.traits(of: currentFont).contains(.boldFontMask), currentAttrs, currentFont)
    }
    /// Public function to get if is bold `no information`
    public func isCurrentlyBold() -> Bool {
        let currentAttrs = textView.typingAttributes
        let currentFont = currentAttrs[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return fontManager.traits(of: currentFont).contains(.boldFontMask)
    }
}


// MARK: - Increase / Decrease Font
extension TextViewController {
    
    /// Public function to increase the font or zoom in
    /// If is selecting something, then it increases the font under it
    /// if is not, then zooms in
    public func increaseFontOrZoomIn() {
        guard isAppActive else { return }
        
        if let range = textDelegate.range, range.length > 0 {
            guard let storage = textView.textStorage else { return }
            updateFont(range, storage: storage, increase: true)
            textDelegate.forceFontRefresh(textView: textView)
        } else {
            let newMag = scrollView.magnification + 0.1
            scrollView.setZoom(newMag)
        }
    }
    
    /// Public function to increase the font or zoom in
    /// If is selecting something, then it decreases the font under it
    /// if is not, then zooms out
    public func decreaseFontOrZoomOut() {
        guard isAppActive else { return }
        
        if let range = textDelegate.range, range.length > 0 {
            guard let storage = textView.textStorage else { return }
            updateFont(range, storage: storage, increase: false)
            textDelegate.forceFontRefresh(textView: textView)
        } else {
            let newMag = scrollView.magnification - 0.1
            scrollView.setZoom(newMag)
        }
    }
    
    /// Internal function to update the font, is useful while increasing/decreasing font
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
