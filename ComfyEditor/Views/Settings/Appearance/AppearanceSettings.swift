//
//  AppearanceSettings.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct AppearanceSettings: View {
    var body: some View {
        SettingsContainerView {
            SettingsSection("Editor Theme") {
                ThemeSettings()
            }
        }
    }
}
