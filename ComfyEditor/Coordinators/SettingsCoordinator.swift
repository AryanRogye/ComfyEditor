//
//  SettingsCoordinator.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Defaults

extension Defaults.Keys {
    static let isVimEnabled = Key<Bool>("isVimEnabled", default: false)
    static let showScrollbar = Key<Bool>("showScrollbar", default: true)
}

@Observable @MainActor
final class SettingsCoordinator {
    
    /// flag to know if we're showing the winodw or not
    var isShowing = false
    
    let windowCoordinator : WindowCoordinator
    let configPath: URL
    var themeCoordinator: ThemeCoordinator?
    let fileManagement : FileManagementProviding
    let dateFormatter : DateFormatter
    let timeFormatter : DateFormatter

    var isVimEnabled: Bool = Defaults[.isVimEnabled]  {
        didSet {
            Defaults[.isVimEnabled] = isVimEnabled
        }
    }
    var showScrollbar: Bool = Defaults[.showScrollbar] {
        didSet {
            Defaults[.showScrollbar] = showScrollbar
        }
    }
    
    init(windowCoordinator: WindowCoordinator) {
        self.windowCoordinator = windowCoordinator
        configPath = Self.comfyEditorConfigDirectory()
        print("Config Path: \(configPath)")
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd" // customize as needed
        
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = .current
        timeFormatter.dateFormat = "HH-mm-ss" // 24h; use "h:mm a" for 12h
        
        fileManagement = FileManagementService(fileManager: FileManager.default)
    }
    
}

extension SettingsCoordinator {
    
    /// Creates a Default Project Directory
    @discardableResult
    public func createDefaultProjectDirectory() async -> URL? {
        let date = dateFormatter.string(from: .now)
        let time = timeFormatter.string(from: .now)
        
        let name = "Untitled-\(date)-\(time)"
        do {
            let url = try await fileManagement.createDirectory(
                directory: configPath,
                named: name
            )
            return url
        } catch {
            print("Error Creating File: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// This will open the ApplicationSupport Folder
    public func openInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([configPath])
    }
    
    private static func comfyEditorConfigDirectory() -> URL {
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
        guard let themeCoordinator else { return }
        guard !isShowing else { return }
        windowCoordinator.showWindow(
            id: UUID().uuidString,
            title: "Settings",
            content: SettingsView(themeCoordinator: themeCoordinator),
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
