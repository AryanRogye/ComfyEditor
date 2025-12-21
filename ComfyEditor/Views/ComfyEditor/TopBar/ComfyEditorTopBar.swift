//
//  ComfyEditorTopBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorTopBar: View {
    
    @State var editorCommandCenter = EditorCommandCenter.shared
    @Bindable var settingsCoordinator: SettingsCoordinator
    
    let shape = UnevenRoundedRectangle(
        topLeadingRadius: 8,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 0,
        topTrailingRadius: 8,
        style: .continuous
    )
    
    private let magnificationText = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        return f
    }()
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 77)
            
            TopBarDivider()
            
            TopBarButton(
                content: .text("B"),
                selection: Binding(
                    get: { editorCommandCenter.isBoldEnabled },
                    set: { _ in }
                )
            )
            
            TopBarDivider()

            TopBarButton(
                content: .systemImage("minus"),
                selection: .constant(false),
                isButton: true,
                action: { }
            )
            
            TopBarDivider()

            if let currentFont = editorCommandCenter.currentFont {
                TopBarButton(
                    content: .value(currentFont),
                    selection: .constant(false)
                )
            } else {
                TopBarButton(
                    content: .text("_"),
                    selection: .constant(false)
                )
            }
            TopBarDivider()

            TopBarButton(
                content: .systemImage("plus"),
                selection: .constant(false),
                isButton: true,
                action: { }
            )
            TopBarDivider()
        
            TopBarButton(
                content: .label(
                    magnificationText.string(from: editorCommandCenter.magnification as NSNumber) ?? "–",
                    "magnifyingglass"
                ),
                selection: .constant(false)
            )
            
            TopBarDivider()

            TopBarButton(
                content: .text("V"),
                selection: $settingsCoordinator.isVimEnabled
            )
            TopBarDivider()

            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: 35)
        .clipShape(
            shape
        )
        .overlay {
            shape
                .stroke(.white.opacity(0.25), lineWidth: 1)
        }
    }
}
