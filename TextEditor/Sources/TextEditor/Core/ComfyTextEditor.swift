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
    @Binding var editorBackground: Color
    /// Color of the text
    @Binding var editorForegroundStyle: Color
    /// Border Radius of the entire editor
    var borderRadius: CGFloat
    
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        isInVimMode: Binding<Bool>,
        editorBackground: Binding<Color>,
        editorForegroundStyle: Binding<Color>,
        borderRadius: CGFloat
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = isInVimMode
        self._editorBackground = editorBackground
        self._editorForegroundStyle = editorForegroundStyle
        self.borderRadius = borderRadius
    }
    
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        borderRadius: CGFloat,
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = .constant(false)
        self._editorBackground = .constant(.white)
        self._editorForegroundStyle = .constant(.black)
        self.borderRadius = borderRadius
    }
    
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        editorBackground: Binding<Color>,
        editorForegroundStyle: Binding<Color>,
        borderRadius: CGFloat
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._editorBackground = editorBackground
        self._editorForegroundStyle = editorForegroundStyle
        self._isInVimMode = .constant(false)
        self.borderRadius = borderRadius
    }
    
    public func makeNSViewController(context: Context) -> TextViewController {
        let viewController = TextViewController()
        viewController.textView.string = text
        viewController.textView.backgroundColor = NSColor(editorBackground)
        viewController.vimBottomView.setBackground(color: NSColor(editorBackground))
        viewController.textView.textColor = NSColor(editorForegroundStyle)
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
        
        if nsViewController.textView.backgroundColor != NSColor(editorBackground) {
            nsViewController.textView.backgroundColor = NSColor(editorBackground)
            nsViewController.vimBottomView.setBackground(color: NSColor(editorBackground))
        }
        
        if nsViewController.textView.textColor != NSColor(editorForegroundStyle) {
            nsViewController.textView.textColor = NSColor(editorForegroundStyle)
        }
    }
}
