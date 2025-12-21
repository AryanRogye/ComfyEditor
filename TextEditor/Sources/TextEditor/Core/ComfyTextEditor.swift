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

    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        isInVimMode: Binding<Bool>,
        editorBackground: Color,
        editorForegroundStyle: Color,
        borderColor: Color,
        borderRadius: CGFloat,
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = isInVimMode
        self.editorBackground = editorBackground
        self.editorForegroundStyle = editorForegroundStyle
        self.borderRadius = borderRadius
        self.borderColor = borderColor
    }

    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        borderRadius: CGFloat,
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = .constant(false)
        self.editorBackground = .white
        self.editorForegroundStyle = .black
        self.borderRadius = borderRadius
        self.borderColor = .gray.opacity(0.3)
    }

    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        editorBackground: Color,
        editorForegroundStyle: Color,
        borderColor: Color,
        borderRadius: CGFloat
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self.editorBackground = editorBackground
        self.editorForegroundStyle = editorForegroundStyle
        self._isInVimMode = .constant(false)
        self.borderRadius = borderRadius
        self.borderColor = borderColor
    }

    public func makeNSViewController(context: Context) -> TextViewController {
        let viewController = TextViewController(foregroundStyle: editorForegroundStyle)
        viewController.textView.string = text
        viewController.textView.layer?.backgroundColor = NSColor(editorBackground).cgColor
        viewController.setEditorBackground(NSColor(editorBackground))
        viewController.vimBottomView.setBackground(color: NSColor(editorBackground))
        viewController.textView.textColor = NSColor(editorForegroundStyle)
        viewController.vimBottomView.setBorderColor(color: NSColor(borderColor))
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
