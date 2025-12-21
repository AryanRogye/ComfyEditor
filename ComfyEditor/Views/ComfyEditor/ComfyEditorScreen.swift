//
//  ComfyEditorScreen.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 11/29/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorScreen: View {
    
    var cameFromOtherView : Bool = false
    var pop: () -> Void = { }
    
    @Bindable var editorCommandCenter = EditorCommandCenter.shared
    @Bindable var settingsCoordinator : SettingsCoordinator
    @Bindable var themeCoordinator    : ThemeCoordinator
    
    @State private var shouldRefreshTrafficLights = false
    
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
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ComfyEditorFrameView(
            backgroundColor : themeCoordinator.currentTheme.theme.primaryBackground,
            borderColor     : themeCoordinator.currentTheme.theme.borderColor
        ) {
            /// Editor View
            ComfyTextEditor(
                text                    : $text,
                showScrollbar           : $settingsCoordinator.showScrollbar,
                isInVimMode             : $settingsCoordinator.isVimEnabled,
                editorBackground        : themeCoordinator.currentTheme.theme.secondaryBackground,
                editorForegroundStyle   : themeCoordinator.currentTheme.theme.primaryForegroundStyle,
                borderColor             : themeCoordinator.currentTheme.theme.borderColor,
                borderRadius            : 8,
            )
            .modifier(VimToggleViewModifier(settingsCoordinator: settingsCoordinator))
            
        } topBar: {
            ComfyEditorTopBar(
                settingsCoordinator: settingsCoordinator,
                themeCoordinator   : themeCoordinator,
                cameFromOtherView  : cameFromOtherView,
                pop                : superPop,
            )
        }
        .frame(minWidth: 600, minHeight: 400)
        .navigationBarBackButtonHidden()
        .windowTitlebarArea(
            shouldShowContent: .constant(false),
            shouldHideTrafficLights: .constant(false),
            shouldRefreshTrafficLights: $shouldRefreshTrafficLights,
            content: { }
        )
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                shouldRefreshTrafficLights = true
            case .inactive, .background:
                shouldRefreshTrafficLights = false
            @unknown default:
                break
            }
        }
    }
    
    func superPop() {
        pop()
        shouldRefreshTrafficLights = true
    }
}

struct VimToggleViewModifier: ViewModifier {
    
    @Bindable var settingsCoordinator: SettingsCoordinator
    @State private var shouldShowVimEnabledOverlay: Bool = false
    
    func body(content: Content) -> some View {
        content
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
    }
}

