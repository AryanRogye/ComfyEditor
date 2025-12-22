//
//  SettingsView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

struct SettingsView: View {

    @State var settingsVM = SettingsViewModel()
    @Bindable var themeCoordinator: ThemeCoordinator

    var body: some View {
        NavigationSplitView {

            sidebar

        } detail: {

            settingsVM.selectedTab.view
                .environment(themeCoordinator)

        }
        .navigationSplitViewStyle(.balanced)
    }

    private var sidebar: some View {
        List(selection: $settingsVM.selectedTab) {
            ForEach(SettingsTab.allCases, id: \.self) { tab in
                Label(tab.rawValue, systemImage: tab.icon)
                    .tag(tab)
            }
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(200)
    }
}


#Preview {
    SettingsView(settingsVM: SettingsViewModel(), themeCoordinator: ThemeCoordinator())
}
