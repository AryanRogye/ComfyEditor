//
//  ComfyEditorHome.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/3/25.
//

import SwiftUI

struct ComfyEditorHome: View {
    
    @Environment(SettingsCoordinator.self) var settingsCoordinator

    // Adaptive grid for responsive layout
    let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Projects")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.top, 40)

                LazyVGrid(columns: columns, spacing: 20) {
                    addButton
                    /// More Projects will go right here
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    @ViewBuilder
    private var addButton: some View {
        @Bindable var settingsCoordinator = settingsCoordinator
        // Add Project Button
        NavigationLink(destination: ComfyEditorScreen(settingsCoordinator: settingsCoordinator)) {
            VStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.secondary)

                Text("New Project")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundStyle(.tertiary)
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5).cornerRadius(12))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ComfyEditorHome()
        .frame(width: 800, height: 600)
}
