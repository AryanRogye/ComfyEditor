//
//  AppDelegate.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    let appCoordinator: AppCoordinator
    
    @MainActor
    override init() {
        appCoordinator = AppCoordinator()
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
