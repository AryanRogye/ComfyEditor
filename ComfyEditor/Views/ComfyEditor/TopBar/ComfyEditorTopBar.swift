//
//  ComfyEditorTopBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI
import TextEditor
import Combine

struct ComfyEditorTopBar: View {

    @Bindable var settingsCoordinator: SettingsCoordinator
    @Bindable var themeCoordinator   : ThemeCoordinator
    @Bindable var comfyEditorVM      : ComfyEditorViewModel

    var cameFromOtherView : Bool = false
    var pop: () -> Void = { }

    @State private var statusText: String = "Not saved yet"
    @State private var pendingStatusTask: Task<Void, Never>?
    @State private var savingStartedAt: Date?
    private let relativeFormatter = RelativeTimeFormatter()
    private let statusTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

            lastSavedStatus

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
        .onAppear { refreshStatus() }
        .onChange(of: comfyEditorVM.isSaving) { _, newValue in
            if newValue {
                showSavingState()
            } else {
                updateSavedState(with: comfyEditorVM.lastSaved)
            }
        }
        .onChange(of: comfyEditorVM.lastSaved) { _, newValue in
            guard !comfyEditorVM.isSaving else { return }
            updateSavedState(with: newValue)
        }
        .onDisappear {
            pendingStatusTask?.cancel()
        }
        .onReceive(statusTimer) { _ in
            guard !comfyEditorVM.isSaving else { return }
            guard let lastSaved = comfyEditorVM.lastSaved else { return }
            statusText = "Saved \(relativeFormatter.string(since: lastSaved))"
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
            content: .text(projectTitle),
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

    // MARK: - Last Saved
    @ViewBuilder
    private var lastSavedStatus: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            TopBarButton(
                content: .label(statusText, "clock"),
                selection: .constant(false),
                ignoreWidth: true,
                foregroundStyle: themeCoordinator.currentTheme.theme.secondaryForegroundStyle
            )
        }
        .frame(width: 120, alignment: .leading)
    }

    private var projectTitle: String {
        comfyEditorVM.projectURL?.lastPathComponent ?? "DEBUG"
    }

    private func refreshStatus() {
        if comfyEditorVM.isSaving {
            showSavingState()
        } else {
            updateSavedState(with: comfyEditorVM.lastSaved)
        }
    }

    private func showSavingState() {
        pendingStatusTask?.cancel()
        savingStartedAt = .now
        withAnimation(.easeInOut) {
            statusText = "Saving..."
        }
    }

    private func updateSavedState(with date: Date?) {
        pendingStatusTask?.cancel()
        guard let date else {
            withAnimation(.easeInOut) {
                statusText = "Not saved yet"
            }
            return
        }

        let elapsed = savingStartedAt.map { Date().timeIntervalSince($0) } ?? 0
        let minimumVisibleTime: TimeInterval = 0.6
        let delay = max(minimumVisibleTime - elapsed, 0)

        pendingStatusTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            withAnimation(.easeInOut) {
                statusText = "Saved \(relativeFormatter.string(since: date))"
            }
        }
    }
}

private struct RelativeTimeFormatter {
    func string(since date: Date, now: Date = .now) -> String {
        let seconds = max(Int(now.timeIntervalSince(date)), 1)

        if seconds < 60 {
            return format(seconds, unit: "second")
        }

        let minutes = seconds / 60
        if minutes < 60 {
            return format(minutes, unit: "minute")
        }

        let hours = minutes / 60
        if hours < 24 {
            return format(hours, unit: "hour")
        }

        let days = hours / 24
        let remainingHours = hours % 24

        if remainingHours > 0 {
            return "\(format(days, unit: "day")) \(format(remainingHours, unit: "hour")) ago"
        }

        return "\(format(days, unit: "day")) ago"
    }

    private func format(_ value: Int, unit: String) -> String {
        let pluralized = value == 1 ? unit : "\(unit)s"
        return "\(value) \(pluralized) ago"
    }
}
