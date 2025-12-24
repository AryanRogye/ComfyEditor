//
//  ComfyEditorHome.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/3/25.
//

import SwiftUI

enum Route: Hashable {
    case editor(
        cameFromOtherView: Bool,
    )
}

struct ComfyEditorHome: View {

    @Environment(SettingsCoordinator.self) var settingsCoordinator
    @Environment(ThemeCoordinator.self) var themeCoordinator
    @State private var comfyEditorVM = ComfyEditorViewModel()
    @State private var path: [Route] = []

    // Adaptive grid for responsive layout
    let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 20)
    ]

    var body: some View {
        contentView
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .editor(let cameFromOtherView):
                    ComfyEditorScreen(
                        cameFromOtherView: cameFromOtherView,
                        pop: { path.removeLast() },
                        settingsCoordinator: settingsCoordinator,
                        themeCoordinator: themeCoordinator,
                        comfyEditorVM: comfyEditorVM
                    )
                }
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        @Bindable var themeCoordinator = themeCoordinator
        let theme = themeCoordinator.currentTheme.theme
        
        ZStack(alignment: .topLeading) {
            theme.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("Projects")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.primaryForegroundStyle)
                        .padding(.horizontal, 32)
                        .padding(.top, 40)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        addButton(theme: theme)
                        /// More Projects will go right here
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    @ViewBuilder
    private func addButton(theme: Theme) -> some View {
        @Bindable var settingsCoordinator = settingsCoordinator
        @Bindable var themeCoordinator = themeCoordinator
        // Add Project Button
        NavigationStack(path: $path) {
            
            Button {
                Task {
                    /// Create Default Project Directory
                    if let url = await settingsCoordinator.createDefaultProjectDirectory() {
                        
                        /// Set Project URL in the VM
                        comfyEditorVM.projectURL = url
                        
                        /// set Editor to this
                        await MainActor.run {
                            path.append(.editor(
                                cameFromOtherView: true,
                            ))
                        }
                    }
                }
            } label: {
                addButtonView(theme: theme)
            }
            .tint(theme.primaryForegroundStyle)
        }
        .buttonStyle(.plain)
    }
    
    private func addButtonView(theme: Theme) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(theme.primaryForegroundStyle.opacity(0.75))
            
            Text("New Project")
                .font(.headline)
                .foregroundStyle(theme.primaryForegroundStyle)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(theme.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                        .foregroundStyle(theme.borderColor)
                )
        }
    }
}

#Preview {
    ComfyEditorHome()
        .frame(width: 800, height: 600)
}
