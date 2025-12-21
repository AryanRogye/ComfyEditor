//
//  SettingsView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

struct SettingsView: View {
    
    @Bindable var themeCoordinator : ThemeCoordinator

    var body: some View {
        VStack {
            ThemeSettings(themeCoordinator: themeCoordinator)
        }
        .frame(width: 400, height: 400)
    }
}

struct ThemeSettings: View {
    
    @Bindable var themeCoordinator : ThemeCoordinator
    
    var body: some View {
        VStack {
            Text("Selected: \(themeCoordinator.currentTheme.name)")
            ForEach(themeCoordinator.themes, id: \.id) { theme in
                Button(action: {
                    themeCoordinator.currentTheme = theme
                }) {
                    Text(theme.name)
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                }
            }
        }
    }
}
