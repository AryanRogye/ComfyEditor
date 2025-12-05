//
//  SettingsManager.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Defaults

extension Defaults.Keys {
    static let isVimEnabled = Key<Bool>("isVimEnabled", default: false)
}

@Observable @MainActor
final class SettingsCoordinator {
    
    /// flag to know if we're showing the winodw or not
    var isShowing = false
    
    let windowCoordinator : WindowCoordinator
    let applicationSupport: URL
    let configPath: URL
    
    var isVimEnabled: Bool = Defaults[.isVimEnabled]  {
        didSet {
            Defaults[.isVimEnabled] = isVimEnabled
        }
    }
    
    init(windowCoordinator: WindowCoordinator) {
        self.windowCoordinator = windowCoordinator
        applicationSupport = Self.comfyEditorConfigDirectory()
        configPath = Self.getOrCreateConfigJson()
    }
}

extension SettingsCoordinator {
    /// creates or gets the config.json file in the applicationSupport folder
    static func getOrCreateConfigJson() -> URL {
        let fm = FileManager.default
        
        let dir = comfyEditorConfigDirectory()
        let file = dir.appendingPathComponent("config.json")
        
        // If file doesn’t exist, create an empty `{}` config
        if !fm.fileExists(atPath: file.path) {
            let empty: [String: Any] = [:]
            let data = try? JSONSerialization.data(withJSONObject: empty, options: [.prettyPrinted])
            fm.createFile(atPath: file.path, contents: data)
        }
        
        return file
    }
    
    static func comfyEditorConfigDirectory() -> URL {
        let fm = FileManager.default
        
        // ~/Library/Application Support
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        
        // ~/Library/Application Support/ComfyEditor
        let folder = base.appendingPathComponent("ComfyEditor", isDirectory: true)
        
        // create if missing
        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        
        return folder
    }
}

extension SettingsCoordinator {
    /// Function to open the window
    func showWindow() {
        guard !isShowing else { return }
        windowCoordinator.showWindow(
            id: UUID().uuidString,
            title: "Settings",
            content: SettingsView(),
            onOpen: { [weak self] in
                guard let self = self else { return }
                self.isShowing = true
            },
            onClose: { [weak self] in
                guard let self = self else { return }
                isShowing = false
            }
        )
    }
}
