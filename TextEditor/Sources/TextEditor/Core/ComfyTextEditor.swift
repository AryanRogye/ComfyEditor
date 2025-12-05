//
//  Editor.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

public struct ComfyTextEditor: NSViewControllerRepresentable {
    
    @Binding var text: String
    @Binding var isInVimMode: Bool
    @Binding var showScrollbar: Bool
    
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
        isInVimMode: Binding<Bool>
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = isInVimMode
    }
    
    public init(
        text: Binding<String>,
        showScrollbar: Binding<Bool>,
    ) {
        self._text = text
        self._showScrollbar = showScrollbar
        self._isInVimMode = .constant(false)
    }
    
    
    public func makeNSViewController(context: Context) -> TextViewController {
        let viewController = TextViewController()
        return viewController
    }
    
    public func updateNSViewController(_ nsViewController: TextViewController, context: Context) {
        
        /// Update if is inVimMode or not
        if nsViewController.textView.isInVimMode != isInVimMode {
            nsViewController.textView.isInVimMode = isInVimMode
        }
        
        if nsViewController.scrollView.hasVerticalScroller != showScrollbar {
            nsViewController.scrollView.hasVerticalScroller = showScrollbar
        }
    }
}
