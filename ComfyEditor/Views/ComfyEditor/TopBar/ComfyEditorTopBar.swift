//
//  ComfyEditorTopBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorTopBar: View {

    @Bindable var settingsCoordinator: SettingsCoordinator
    @Bindable var themeCoordinator   : ThemeCoordinator
    @Bindable var comfyEditorVM      : ComfyEditorViewModel

    var cameFromOtherView : Bool = false
    var pop: () -> Void = { }

    private let magnificationText = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        return f
    }()

    let height : CGFloat = 35

    private var divider: some View {
        TopBarDivider(themeCoordinator.currentTheme.theme.secondaryBorderColor, height - 1)
    }

    var body: some View {
        HStack(spacing: 0) {

            /// This is Traffic Light Space
            Spacer()
                .frame(width: 77)

            backButton
            
            divider
            
            projectName

            divider

            bold

            divider

            minus

            divider

            currentFont

            divider

            plus

            divider

            zoom

            divider

            vim

            divider
            
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
                .stroke(themeCoordinator.currentTheme.theme.borderColor, lineWidth: 1)
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

    // MARK: - Back Button
    @ViewBuilder
    private var backButton: some View {
        if cameFromOtherView {
            TopBarButton(
                content: .systemImage("arrow.left"),
                selection: .constant(false),
                isButton: true,
                foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
                action: pop,
            )
        }
    }
    
    // MARK: - Project Name
    @ViewBuilder
    private var projectName: some View {
        TopBarButton(
            content: .text("\(comfyEditorVM.projectURL?.lastPathComponent, default: "DEBUG")"),
            selection: .constant(false),
            ignoreWidth: true,
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
        )
    }

    // MARK: - Bold
    private var bold: some View {
        TopBarButton(
            content: .text("B"),
            selection: $comfyEditorVM.isBold,
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
        )
    }

    // MARK: - Minus
    private var minus: some View {
        TopBarButton(
            content: .systemImage("minus"),
            selection: .constant(false),
            isButton: true,
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
            action: { }
        )
    }

    // MARK: - Current Font
    private var currentFont: some View {
        TopBarButton(
            content: .value(comfyEditorVM.font),
            selection: .constant(false),
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
        )
    }

    // MARK: - Plus
    private var plus: some View {
        TopBarButton(
            content: .systemImage("plus"),
            selection: .constant(false),
            isButton: true,
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
            action: { }
        )
    }

    // MARK: - Zoom
    private var zoom: some View {
        TopBarButton(
            content: .label(
                magnificationText.string(from: comfyEditorVM.magnification as NSNumber) ?? "–",
                "magnifyingglass"
            ),
            selection: .constant(false),
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
        )
    }

    // MARK: - Vim
    private var vim: some View {
        TopBarButton(
            content: .text("V"),
            selection: $settingsCoordinator.isVimEnabled,
            foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle,
        )
    }
}
