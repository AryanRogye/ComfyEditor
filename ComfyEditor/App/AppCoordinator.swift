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
    let keybindCoordinator : KeybindCoordinator
    let settingsCoordinator : SettingsCoordinator
    
    init() {
        keybindCoordinator = KeybindCoordinator(windowCoordinator: windowCoordinator)
        settingsCoordinator = SettingsCoordinator(windowCoordinator: windowCoordinator)
    }
}
