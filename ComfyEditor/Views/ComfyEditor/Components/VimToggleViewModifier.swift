//
//  VimToggleViewModifier.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import SwiftUI

struct VimToggleViewModifier: ViewModifier {
    
    @Bindable var settingsCoordinator: SettingsCoordinator
    @State private var shouldShowVimEnabledOverlay: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: settingsCoordinator.isVimEnabled) { _, newValue in
                withAnimation {
                    self.shouldShowVimEnabledOverlay = true
                }
                
                // auto-hide
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        self.shouldShowVimEnabledOverlay = false
                    }
                }
            }
            .overlay {
                if shouldShowVimEnabledOverlay {
                    VStack {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .font(.system(size: 36, weight: .semibold, design: .monospaced))
                        
                        Text("Vim Mode \(settingsCoordinator.isVimEnabled ? "On" : "Off")")
                            .font(.system(.headline, design: .monospaced))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    )
                    .shadow(radius: 12)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: shouldShowVimEnabledOverlay)
    }
}
