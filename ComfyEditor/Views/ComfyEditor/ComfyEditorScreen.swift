//
//  ComfyEditorScreen.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 11/29/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorScreen: View {
    
    @Bindable var editorCommandCenter = EditorCommandCenter.shared
    @Bindable var settingsCoordinator : SettingsCoordinator
    
    @State var text: String = """
        
        /// TEST MOVE UP HERE
        /// SET Cursor on t and move up 2 times, make sure on t on 2nd
        func textViewDidChangeSelection(_ notification: Notification)
        //
        func textViewDidChangeSelection(_ notification: Notification)
        
        
        //
        //  TextViewCursorDelegate.swift
        //  TextEditor
        //
        //  Created by Aryan Rogye on 12/6/25.
        //
        
        import AppKit
        
        @MainActor
        protocol TextViewCursorDelegate: AnyObject {
        var isOnNewline: Bool { get }
        func textViewDidChangeSelection(_ notification: Notification)
        }
        """
    
    @State private var shouldShowVimEnabledOverlay = false
    var body: some View {
        VStack(spacing: 0) {
            ComfyTextEditor(
                text: $text,
                showScrollbar: $settingsCoordinator.showScrollbar,
                isInVimMode: $settingsCoordinator.isVimEnabled
            )
            .frame(minWidth: 600, minHeight: 400)
        }
        .onChange(of: settingsCoordinator.isVimEnabled) { _, newValue in
            withAnimation {
                self.shouldShowVimEnabledOverlay = true
            }
            
            // auto-hide
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.shouldShowVimEnabledOverlay = false
                }
            }
        }
        .overlay {
            if shouldShowVimEnabledOverlay {
                VStack {
                    Image(systemName: "chevron.left.slash.chevron.right")
                        .font(.system(size: 36, weight: .semibold, design: .monospaced))
                    
                    Text("Vim Mode \(settingsCoordinator.isVimEnabled ? "On" : "Off")")
                        .font(.system(.headline, design: .monospaced))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
                .shadow(radius: 12)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: shouldShowVimEnabledOverlay)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "sidebar.left")
                }
            }
            ToolbarItem {
                Button(action: {
                    editorCommandCenter.toggleBold()
                }) {
                    Text("B")
                        .bold()
                        .padding(6)
                        .background(editorCommandCenter.isBoldEnabled ? Color.accentColor : Color.clear)
                        .foregroundColor(editorCommandCenter.isBoldEnabled ? .white : .primary)
                        .cornerRadius(4)
                }
            }
            
            ToolbarItemGroup {
                Button(action: { }) { Image(systemName: "minus") }
                Text("\(editorCommandCenter.currentFont, default: "_")")
                    .font(.body)
                    .padding(6)
                Button(action: { }) { Image(systemName: "plus") }
            }
            ToolbarSpacer(.fixed)
            ToolbarItemGroup {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                    Text("\(editorCommandCenter.magnification, specifier: "%.1f")")
                }
                .padding(6)
            }
            ToolbarItemGroup {
                Text("V")
                    .bold()
                    .padding(6)
                    .background(settingsCoordinator.isVimEnabled ? Color.accentColor : Color.clear)
                    .foregroundColor(settingsCoordinator.isVimEnabled ? .white : .primary)
                    .cornerRadius(4)
                    .padding(.trailing, 8)
            }
            
        }
        .toolbarRole(.editor)
    }
}
