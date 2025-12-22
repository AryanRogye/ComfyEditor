//
//  SettingsTab.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

enum SettingsTab: String, CaseIterable {
    case general = "General"
    case appearance = "Appearance"

    var icon: String {
        switch self {
        case .general: return "gear"
        case .appearance: return "paintbrush"
        }
    }

    @ViewBuilder
    public var view: some View {
        switch self {
        case .general: GeneralSettings()
        case .appearance: AppearanceSettings()
        }
    }
}
