//
//  Editor.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

public struct ComfyTextEditor: NSViewControllerRepresentable {

    /// Text to type into
    @Binding var text: String
    
    /// TODO: COMMENT
    @Binding var font: CGFloat
    @Binding var magnification: CGFloat
    @Binding var isBold       : Bool
    
    /// Boolean if is in VimMode or not
    @Binding var isInVimMode: Bool
    /// Boolean if is showing scrollbar or not
    @Binding var showScrollbar: Bool
    /// Color of the editor background
    var editorBackground: Color
    /// Color of the text
    var editorForegroundStyle: Color
    /// Color of the border
    var borderColor: Color
    /// Border Radius of the entire editor
    var borderRadius: CGFloat
    
    let textViewDelegate = TextViewDelegate()
    let magnificationDelegate = MagnificationDelegate()
    
    var onReady: (EditorCommands) -> Void
    var onSave : () -> Void

    public init(
        text: Binding<String>,
        font: Binding<CGFloat> = .constant(0),
        isBold: Binding<Bool>,
        magnification: Binding<CGFloat> = .constant(1),
        showScrollbar: Binding<Bool>,
        borderRadius: CGFloat = 8,
        isInVimMode: Binding<Bool> = .constant(false),
        editorBackground: Color = .white,
        editorForegroundStyle: Color = .black,
        borderColor: Color = Color.gray.opacity(0.3),
        onReady: @escaping (EditorCommands) -> Void = { _ in },
        onSave : @escaping () -> Void = { },
    ) {
        self.onReady = onReady
        self.onSave = onSave
        self._text = text
        self._font = font
        self._magnification = magnification
        self._isBold = isBold
        self._showScrollbar = showScrollbar
        self._isInVimMode = isInVimMode
        self.editorBackground = editorBackground
        self.editorForegroundStyle = editorForegroundStyle
        self.borderRadius = borderRadius
        self.borderColor = borderColor
    }
    
    /// Convenience initializer for simple usage with only text + scrollbar bindings.
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        isInVimMode: Binding<Bool> = .constant(false),
        editorBackground: Color = .white,
        editorForegroundStyle: Color = .black,
        borderColor: Color = Color.gray.opacity(0.3),
        borderRadius: CGFloat = 8
    ) {
        self.init(
            text: text,
            font: .constant(0),
            isBold: .constant(false),
            magnification: .constant(1),
            showScrollbar: showScrollbar,
            borderRadius: borderRadius,
            isInVimMode: isInVimMode,
            editorBackground: editorBackground,
            editorForegroundStyle: editorForegroundStyle,
            borderColor: borderColor,
            onReady: { _ in },
            onSave: { }
        )
    }
    
    public func makeNSViewController(context: Context) -> TextViewController {
        let viewController = TextViewController(
            foregroundStyle       : editorForegroundStyle,
            textViewDelegate      : textViewDelegate,
            magnificationDelegate : magnificationDelegate,
            onSave                : onSave
        )
        onReady(viewController)
        viewController.textView.string = text
        viewController.textView.layer?.backgroundColor = NSColor(editorBackground).cgColor
        viewController.setEditorBackground(NSColor(editorBackground))
        viewController.vimBottomView.setBackground(color: NSColor(editorBackground))
        viewController.textView.textColor = NSColor(editorForegroundStyle)
        viewController.vimBottomView.setBorderColor(color: NSColor(borderColor))
        
        /// Observe Text Changes
        textViewDelegate.observeTextChange($text)
        textViewDelegate.observeFontChange($font)
        textViewDelegate.observeBoldUnderCursor($isBold)
        magnificationDelegate.observeMagnification($magnification)
        
        return viewController
    }

    public func updateNSViewController(_ nsViewController: TextViewController, context: Context) {

        /// Update if is inVimMode or not
        if nsViewController.vimEngine.isInVimMode != isInVimMode {
            DispatchQueue.main.async {
                nsViewController.vimEngine.isInVimMode = isInVimMode

                /// Update's the insertion point
                nsViewController.textView.updateInsertionPointStateAndRestartTimer(true)

            }
        }

        if nsViewController.scrollView.hasVerticalScroller != showScrollbar {
            nsViewController.scrollView.hasVerticalScroller = showScrollbar
        }

        if nsViewController.textView.layer?.backgroundColor != NSColor(editorBackground).cgColor {
            nsViewController.textView.layer?.backgroundColor = NSColor(editorBackground).cgColor
            nsViewController.setEditorBackground(NSColor(editorBackground))
        }

        if nsViewController.vimBottomView.layer?.backgroundColor
            != NSColor(editorBackground).cgColor
        {
            nsViewController.vimBottomView.setBackground(color: NSColor(editorBackground))
        }

        if nsViewController.textView.textColor != NSColor(editorForegroundStyle) {
            nsViewController.vimBottomView.setForegroundStyle(color: editorForegroundStyle)
            nsViewController.textView.textColor = NSColor(editorForegroundStyle)
        }

        if nsViewController.vimBottomView.layer?.borderColor != NSColor(borderColor).cgColor {
            nsViewController.vimBottomView.setBorderColor(color: NSColor(borderColor))
        }
    }
}
