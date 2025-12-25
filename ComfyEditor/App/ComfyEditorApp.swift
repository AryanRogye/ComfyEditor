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
                #if JUST_EDITOR
                ComfyEditorScreen(
                    settingsCoordinator: appDelegate.appCoordinator.settingsCoordinator,
                    themeCoordinator: appDelegate.appCoordinator.themeCoordinator,
                    comfyEditorVM: appDelegate.appCoordinator.comfyEditorVM
                )
                #else
                ComfyEditorHome()
                    .environment(appDelegate.appCoordinator.settingsCoordinator)
                    .environment(appDelegate.appCoordinator.themeCoordinator)
                    .environment(appDelegate.appCoordinator.comfyEditorVM)
                #endif
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
