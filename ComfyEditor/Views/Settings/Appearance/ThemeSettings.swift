//
//  ThemeSettings.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct ThemeSettings: View {
    
    @Environment(ThemeCoordinator.self) var themeCoordinator
    
    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 16)
    ]
    
    var body: some View {
        @Bindable var themeCoordinator = themeCoordinator
        VStack(alignment: .leading, spacing: 10) {
            
            // Header with current theme
            VStack(alignment: .leading, spacing: 4) {
                Text(themeCoordinator.currentTheme.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 6)
            
            // Theme Grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(themeCoordinator.themes, id: \.id) { theme in
                    ThemeCard(
                        colorTheme: theme,
                        isSelected: theme.id == themeCoordinator.currentTheme.id,
                        action: {
                            themeCoordinator.switchTheme(to: theme)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Theme Card Component
struct ThemeCard: View {
    let colorTheme: ColorTheme
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // Color Preview Area
                ZStack {
                    // Background color from theme
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorTheme.theme.primaryBackground)
                        .frame(height: 60)
                    
                    // Sample text lines to preview theme
                    VStack(alignment: .leading, spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorTheme.theme.primaryForegroundStyle)
                            .frame(width: 40, height: 6)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorTheme.theme.secondaryForegroundStyle)
                            .frame(width: 60, height: 6)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorTheme.theme.borderColor)
                            .frame(width: 50, height: 6)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Theme Name & Selection
                HStack {
                    Text(colorTheme.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(nsColor: .controlBackgroundColor))
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSelected ? Color.accentColor : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1.5
                    )
            )
            .shadow(
                color: isHovering ? .black.opacity(0.15) : .black.opacity(0.05),
                radius: isHovering ? 8 : 4,
                y: isHovering ? 4 : 2
            )
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isHovering)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
