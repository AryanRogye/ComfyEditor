//
//  ComfyEditorHome.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/3/25.
//

import SwiftUI

enum Route: Hashable {
    case editor(cameFromOtherView: Bool)
}

struct ComfyEditorHome: View {

    @Environment(SettingsCoordinator.self) var settingsCoordinator
    @Environment(ThemeCoordinator.self) var themeCoordinator
    @State private var path: [Route] = []

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
        @Bindable var themeCoordinator = themeCoordinator
        // Add Project Button
        NavigationStack(path: $path) {
            NavigationLink(value: Route.editor(cameFromOtherView: true)) {
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .editor(let cameFromOtherView):
                    ComfyEditorScreen(
                        cameFromOtherView: cameFromOtherView,
                        pop: { path.removeLast() },
                        settingsCoordinator: settingsCoordinator,
                        themeCoordinator: themeCoordinator
                    )
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ComfyEditorHome()
        .frame(width: 800, height: 600)
}
