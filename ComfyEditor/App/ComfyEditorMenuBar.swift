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
        
        /// Removes File/New Window Option
        CommandGroup(replacing: .newItem) {
        }
        
        /// Removes Edit Option
        CommandGroup(replacing: .pasteboard) { }
        CommandGroup(replacing: .undoRedo) { }
        
        /// Name of Project "ComfyEditor"
        CommandGroup(after: .appSettings) {
            
            /// Settings
            Button(action: settingsCoordinator.showWindow) {
                Label("Settings", systemImage: "gear")
            }.keyboardShortcut(",", modifiers: .command)
            
            /// Keyboard Shortcuts
            Button(action: keybindCoordinator.showWindow) {
                Label("Keybindings", systemImage: "keyboard")
            }
        }
        
        /// Storage Configurations
        CommandMenu("Library") {
            Button(action: settingsCoordinator.openInFinder) {
                Label("Show In Finder", systemImage: "folder.fill")
            }
        }
        
        /// Editor Configurations
        CommandMenu("Editor") {
            Toggle("Vim Mode", isOn: $settingsCoordinator.isVimEnabled)
            Toggle("Show Scrollbar", isOn: $settingsCoordinator.showScrollbar)
        }
    }
}

