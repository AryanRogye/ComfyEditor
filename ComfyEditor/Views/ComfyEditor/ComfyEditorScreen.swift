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

    @Bindable var settingsCoordinator : SettingsCoordinator
    @Bindable var themeCoordinator    : ThemeCoordinator
    @Bindable var comfyEditorVM       : ComfyEditorViewModel

    @State private var shouldRefreshTrafficLights = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ComfyEditorFrameView(
            backgroundColor : themeCoordinator.currentTheme.theme.primaryBackground,
            borderColor     : themeCoordinator.currentTheme.theme.borderColor
        ) {
            /// Editor View
            ComfyTextEditor(
                text                    : $comfyEditorVM.text,
                font                    : $comfyEditorVM.font,
                isBold                  : $comfyEditorVM.isBold,
                magnification           : $comfyEditorVM.magnification,
                showScrollbar           : $settingsCoordinator.showScrollbar,
                borderRadius            : 8,
                isInVimMode             : $settingsCoordinator.isVimEnabled,
                editorBackground        : themeCoordinator.currentTheme.theme.secondaryBackground,
                editorForegroundStyle   : themeCoordinator.currentTheme.theme.primaryForegroundStyle,
                borderColor             : themeCoordinator.currentTheme.theme.borderColor,
                onReady                 : { editorCommands in
                    comfyEditorVM.registerCommands(editorCommands)
                },
                onSave                  : {
                    #if JUST_EDITOR
                    /// In JUST_EDITOR we dont want to save
                    #else
                    comfyEditorVM.saveFile()
                    #endif
                }
            )
            .modifier(VimToggleViewModifier(settingsCoordinator: settingsCoordinator))
            
        } topBar: {
            ComfyEditorTopBar(
                settingsCoordinator: settingsCoordinator,
                themeCoordinator   : themeCoordinator,
                comfyEditorVM      : comfyEditorVM,
                cameFromOtherView  : cameFromOtherView,
                pop                : superPop,
            )
        }
        .onAppear { comfyEditorVM.screen = .editor }
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
        comfyEditorVM.screen = .home
        pop()
        shouldRefreshTrafficLights = true
    }
}
