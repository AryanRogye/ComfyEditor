//
//  AppCoordinator.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

@MainActor
final class AppCoordinator {
    
    let windowCoordinator = WindowCoordinator()
    
    /// Managers
    let keybindCoordinator  : KeybindCoordinator
    let settingsCoordinator : SettingsCoordinator
    let themeCoordinator    : ThemeCoordinator
    let comfyEditorVM       : ComfyEditorViewModel
    
    init() {
        keybindCoordinator  = KeybindCoordinator(windowCoordinator: windowCoordinator)
        settingsCoordinator = SettingsCoordinator(windowCoordinator: windowCoordinator)
        themeCoordinator    = ThemeCoordinator()
        comfyEditorVM = ComfyEditorViewModel()

        keybindCoordinator.setupKeybinds(
            onToggleBold: comfyEditorVM.toggleBold,
            onIncreaseFont: comfyEditorVM.increaseFont,
            onDecreaseFont: comfyEditorVM.decreaseFont
        )
        settingsCoordinator.themeCoordinator = themeCoordinator
    }
}
