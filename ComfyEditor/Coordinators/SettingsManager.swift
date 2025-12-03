//
//  SettingsManager.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit

@Observable @MainActor
final class SettingsCoordinator {
    
    /// flag to know if we're showing the winodw or not
    var isShowing = false
    
    let windowCoordinator : WindowCoordinator
    
    init(windowCoordinator: WindowCoordinator) {
        self.windowCoordinator = windowCoordinator
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
