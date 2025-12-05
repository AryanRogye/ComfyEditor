//
//  ComfyEditorApp.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 11/29/25.
//

import SwiftUI

@main
struct ComfyEditorApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ComfyEditorHome()
                    .environment(appDelegate.appCoordinator.settingsCoordinator)
            }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CustomCommands(
                keybindCoordinator: appDelegate.appCoordinator.keybindCoordinator,
                settingsCoordinator: appDelegate.appCoordinator.settingsCoordinator
            )
        }
    }
}

struct CustomCommands: Commands {
    
    @Bindable var keybindCoordinator : KeybindCoordinator
    @Bindable var settingsCoordinator : SettingsCoordinator
    
    var body: some Commands {
        CommandGroup(after: .appSettings) {
            Button(action: settingsCoordinator.showWindow) {
                Label("Settings", systemImage: "gear")
            }
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
