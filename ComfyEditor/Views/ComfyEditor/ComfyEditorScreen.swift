//
//  ComfyEditorScreen.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 11/29/25.
//

import SwiftUI

struct ComfyEditorScreen: View {
    @State private var source = """
    // InfoView.swift
    // DigitalDetoxBreath
    
    import SwiftUI
    
    struct InfoView: View {
        var body: some View {
            Text("Hello")
        }
    }
    """
    @Bindable var editorCommandCenter = EditorCommandCenter.shared

    var body: some View {
        VStack(spacing: 0) {
            Editor(text: $source)
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
            
        }
        .toolbarRole(.editor)
    }
}
