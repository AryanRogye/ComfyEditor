//
//  ComfyEditorMenuBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import SwiftUI

struct ComfyEditorMenuBar: Commands {
    
    @Bindable var keybindCoordinator : KeybindCoordinator
    @Bindable var settingsCoordinator : SettingsCoordinator
    
    var body: some Commands {
        CommandGroup(after: .appSettings) {
            
            Button(action: settingsCoordinator.showWindow) {
                Label("Settings", systemImage: "gear")
            }.keyboardShortcut(",", modifiers: .command)
            
            Button(action: keybindCoordinator.showWindow) {
                Label("Keybindings", systemImage: "keyboard")
            }
        }
        CommandMenu("Editor") {
            Toggle("Vim Mode", isOn: $settingsCoordinator.isVimEnabled)
            Toggle("Show Scrollbar", isOn: $settingsCoordinator.showScrollbar)
        }
    }
}

