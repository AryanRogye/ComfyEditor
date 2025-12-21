//
//  ComfyEditorTopBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorTopBar: View {
    
    @Bindable var editorCommandCenter = EditorCommandCenter.shared
    @Bindable var settingsCoordinator: SettingsCoordinator
    
    private let magnificationText = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        return f
    }()
    
    let height : CGFloat = 35
    
    var body: some View {
        HStack(spacing: 0) {
            
            /// This is Traffic Light Space
            Spacer()
                .frame(width: 77)
            
            TopBarDivider(height - 1)
            
            bold
            
            TopBarDivider(height - 1)

            minus
            
            TopBarDivider(height - 1)

            currentFont

            TopBarDivider(height - 1)

            plus

            TopBarDivider(height - 1)

            zoom
            
            TopBarDivider(height - 1)

            vim
            
            TopBarDivider(height - 1)

            Spacer()
            
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: height
        )
        .clipShape(
            topBarShape
        )
        .overlay {
            topBarShape
                .stroke(.white.opacity(0.25), lineWidth: 1)
        }
    }
    
    // MARK: - TopBarShape
    let topBarShape = UnevenRoundedRectangle(
        topLeadingRadius: 8,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 0,
        topTrailingRadius: 8,
        style: .continuous
    )

    // MARK: - Bold
    private var bold: some View {
        TopBarButton(
            content: .text("B"),
            selection: Binding(
                get: { editorCommandCenter.isBoldEnabled },
                set: { _ in }
            )
        )
    }
    
    // MARK: - Minus
    private var minus: some View {
        TopBarButton(
            content: .systemImage("minus"),
            selection: .constant(false),
            isButton: true,
            action: { }
        )
    }
    
    // MARK: - Current Font
    private var currentFont: some View {
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
    }
    
    // MARK: - Plus
    private var plus: some View {
        TopBarButton(
            content: .systemImage("plus"),
            selection: .constant(false),
            isButton: true,
            action: { }
        )
    }
    
    // MARK: - Zoom
    private var zoom: some View {
        TopBarButton(
            content: .label(
                magnificationText.string(from: editorCommandCenter.magnification as NSNumber) ?? "–",
                "magnifyingglass"
            ),
            selection: .constant(false)
        )
    }
    
    // MARK: - Vim
    private var vim: some View {
        TopBarButton(
            content: .text("V"),
            selection: $settingsCoordinator.isVimEnabled
        )
    }
}
