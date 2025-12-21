//
//  ThemeCoordinator.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import Foundation
import SwiftUI
import Defaults


extension Defaults.Keys {
    static let selectedThemeID = Key<String>("selectedThemeID", default: "tokyoNight")
}

@Observable @MainActor
final class ThemeCoordinator {
    
    var selectedThemeID: String = Defaults[.selectedThemeID] {
        didSet {
            Defaults[.selectedThemeID] = selectedThemeID
            currentTheme = theme(id: selectedThemeID)
        }
    }
    
    var currentTheme: ColorTheme = .tokyoNight
    
    var themes: [ColorTheme] = [
        .tokyoNight,
        .draculaTheme
    ]
    
    func switchTheme(to theme: ColorTheme) {
        selectedThemeID = theme.id
    }
    
    private func theme(id: String) -> ColorTheme {
        themes.first(where: { $0.id == id }) ?? .tokyoNight
    }
    
    init() {
        currentTheme = theme(id: selectedThemeID)
    }
}
