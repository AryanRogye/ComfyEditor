//
//  KeybindCoordinator.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI
import LocalShortcuts

extension LocalShortcuts.Name {
    /// Toggle Bold
    static let toggleBold = LocalShortcuts.Name(
        "ToggleBold",
        .init(modifier: [.command], keys: [.b])
    )
    /// Increase Font
    static let increaseFont = LocalShortcuts.Name(
        "IncreaseFont",
        .init(modifier: [.command], keys: [.equal])
    )
    /// Decrease Font
    static let decreaseFont = LocalShortcuts.Name(
        "IncreaseFont",
        .init(modifier: [.command], keys: [.minus])
    )
}

@Observable @MainActor
class KeybindCoordinator {
    
    /// Internal flag to let us know if the keybindings view is getting shown or not
    private(set) var isShowing: Bool = false
    
    let windowCoordinator : WindowCoordinator
    
    init(windowCoordinator: WindowCoordinator) {
        self.windowCoordinator = windowCoordinator
        
        handleKeybinds()
    }
}

extension KeybindCoordinator {
    func handleKeybinds() {
        LocalShortcuts.Name.onKeyDown(for: .toggleBold) {
            EditorCommandCenter.shared.toggleBold()
        }
        LocalShortcuts.Name.onKeyDown(for: .increaseFont) {
            EditorCommandCenter.shared.increaseFont()
        }
        LocalShortcuts.Name.onKeyDown(for: .decreaseFont) {
            EditorCommandCenter.shared.decreaseFont()
        }
    }
}



// MARK: - Open Window
extension KeybindCoordinator {
    /// Function to open the window
    func showWindow() {
        guard !isShowing else { return }
        windowCoordinator.showWindow(
            id: UUID().uuidString,
            title: "Keybindings",
            content: KeybindView(),
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
