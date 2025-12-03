//
//  KeybindCoordinator.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleBold = Self("ToggleBold", default: .init(.b, modifiers: [.command]))
    static let increaseFont = Self("IncreaseFont", default: .init(.equal, modifiers: [.command]))
    static let decreaseFont = Self("DecreaseFont", default: .init(.minus , modifiers: [.command]))
}

@Observable @MainActor
class KeybindCoordinator {
    
    /// Keyboard shortcut for toggling bold
    private(set) var toggleBold : KeyboardShortcuts.Name
    
    /// Keyboard shortcut for increasing font
    private(set) var increaseFont : KeyboardShortcuts.Name
    
    /// Keyboard shortcut for decreasing font
    private(set) var decreaseFont : KeyboardShortcuts.Name
    
    /// Internal flag to let us know if the keybindings view is getting shown or not
    private(set) var isShowing: Bool = false
    
    let windowCoordinator : WindowCoordinator
    
    init(windowCoordinator: WindowCoordinator) {
        self.windowCoordinator = windowCoordinator
        
        self.toggleBold = .toggleBold
        self.increaseFont = .increaseFont
        self.decreaseFont = .decreaseFont
        
        handleKeybinds()
    }
}

extension KeybindCoordinator {
    func handleKeybinds() {
        KeyboardShortcuts.onKeyDown(for: .increaseFont, action: {
            EditorCommandCenter.shared.increaseFont()
        })
        KeyboardShortcuts.onKeyDown(for: .decreaseFont, action: {
            EditorCommandCenter.shared.decreaseFont()
        })
        KeyboardShortcuts.onKeyDown(for: .toggleBold, action: {
            EditorCommandCenter.shared.toggleBold()
        })
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
