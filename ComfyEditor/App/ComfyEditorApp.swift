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
            ComfyEditorMenuBar(
                keybindCoordinator: appDelegate.appCoordinator.keybindCoordinator,
                settingsCoordinator: appDelegate.appCoordinator.settingsCoordinator
            )
        }
    }
}
