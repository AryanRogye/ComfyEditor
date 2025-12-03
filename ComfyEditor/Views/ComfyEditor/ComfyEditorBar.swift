//
//  ComfyEditorBar.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

struct ComfyEditorBarButton<Content: View>: View {
    
    var content: Content
    @Binding var selected: Bool
    var onPress: () -> Void
    
    init(
        selected: Binding<Bool> = .constant(false),
        onPress: @escaping () -> Void = { },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selected = selected
        self.content = content()
        self.onPress = onPress
    }
    
    let buttonCornerRadius : CGFloat = 6
    
    var color : Color {
        selected ? .gray.opacity(0.12) : .clear
    }
    var strokeColor: Color {
        selected ? Color.gray.opacity(0.5) : Color.gray.opacity(0.25)
    }
    
    var body: some View {
        Button(action: onPress) {
            content
                .ComfyEditorBarButtonContainer(color: color, strokeColor: strokeColor)
        }
        .buttonStyle(.plain)
    }
}

extension View {
    func ComfyEditorBarButtonContainer(cornerRadius: CGFloat = 6, color: Color, strokeColor: Color) -> some View {
        self
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .stroke(strokeColor, lineWidth: 1)
            }
    }
}

enum ComfyEditorBarMode {
    case toolbar
    case topBar
}

struct ComfyEditorBar: View {
    
    @Bindable var editorCommandCenter = EditorCommandCenter.shared
    var mode: ComfyEditorBarMode = .toolbar
    
    var body: some View {
        switch mode {
        case .toolbar: toolbar
        case .topBar: topBar
        }
    }
    
    @ViewBuilder
    private var toolbar: some View {
        AnyView {
            ToolbarItem(placement: .navigation) {
                Image(systemName: "sidebar.left")
            }
        }
    }
    
    private var topBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ComfyEditorBarButton(onPress: {}) {
                    Image(systemName: "sidebar.left")
                }
                /// first thing is bold button
                ComfyEditorBarButton(selected: $editorCommandCenter.isBoldEnabled, onPress: editorCommandCenter.toggleBold) {
                    Text("B").bold()
                }
                .padding(.vertical, 6)
                
                Text("\(editorCommandCenter.currentFont, default: "_")")
                    .ComfyEditorBarButtonContainer(color: .clear, strokeColor: .gray.opacity(0.5))
            }
            .padding(.horizontal)
            /// no height, the height is decided by its content
            .frame(maxWidth: .infinity)
        }
    }
}
