//
//  ComfyEditorScreen.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 11/29/25.
//

import SwiftUI
import TextEditor

struct ComfyEditorScreen: View {
    
    @Bindable var editorCommandCenter = EditorCommandCenter.shared
    @Bindable var settingsCoordinator : SettingsCoordinator
    
    @State var text: String = """
        TESTING SOMETHING asdfasdf
        sfasdf YO WHATS UP BRO asdfasdf asdf 
        asdf asfasd fasdf asdf asdf asdf asdf asdf asdf asfdasdfasdf a
        as asd;fasd asdf asdf asdf as dfas df
        df asdf asdf asdf asdf asdf asdf asdf sadflkjjjjj;j 
        asdf kjl;k kj ;j kk j; ;kj kj k jj j j j j j j j 
        as asdf asdf asdf asdf asdf asdf asdf asdf asdf 
        df
        asdf asdf asdf asdf as df
        as
        df
        """

    var body: some View {
        VStack(spacing: 0) {
            ComfyTextEditor(
                text: $text,
                showScrollbar: $settingsCoordinator.showScrollbar,
                isInVimMode: $settingsCoordinator.isVimEnabled
            )
                .frame(minWidth: 600, minHeight: 400)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "sidebar.left")
                }
            }
            ToolbarItem {
                Button(action: {
                    editorCommandCenter.toggleBold()
                }) {
                    Text("B")
                        .bold()
                        .padding(6)
                        .background(editorCommandCenter.isBoldEnabled ? Color.accentColor : Color.clear)
                        .foregroundColor(editorCommandCenter.isBoldEnabled ? .white : .primary)
                        .cornerRadius(4)
                }
            }
            
            ToolbarItemGroup {
                Button(action: { }) { Image(systemName: "minus") }
                Text("\(editorCommandCenter.currentFont, default: "_")")
                    .font(.body)
                    .padding(6)
                Button(action: { }) { Image(systemName: "plus") }
            }
            ToolbarSpacer(.fixed)
            ToolbarItemGroup {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                    Text("\(editorCommandCenter.magnification, specifier: "%.1f")")
                }
                .padding(6)
            }
            ToolbarItemGroup {
                Text("V")
                    .bold()
                    .padding(6)
                    .background(settingsCoordinator.isVimEnabled ? Color.accentColor : Color.clear)
                    .foregroundColor(settingsCoordinator.isVimEnabled ? .white : .primary)
                    .cornerRadius(4)
                    .padding(.trailing, 8)
            }
            
        }
        .toolbarRole(.editor)
    }
}
