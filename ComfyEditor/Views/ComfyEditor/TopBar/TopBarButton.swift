//
//  TopBarButton.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct TopBarButton: View {
    
    enum Contents {
        case text(String)
        case value(CGFloat)   // or Double
        case systemImage(String)
        case label(String, String)
    }
    
    var content: Contents?          // <- nil allowed
    @Binding var selection: Bool
    var isButton: Bool = false
    var action: () -> Void = {}
    let labelWidth: CGFloat
    let textWidth : CGFloat
    let foregroundStyle: Color
    
    init(
        content: Contents? = nil,
        selection: Binding<Bool>,
        isButton: Bool = false,
        labelWidth: CGFloat = 50,
        textWidth : CGFloat = 40,
        foregroundStyle: Color,
        action: @escaping () -> Void = {}
    ) {
        self.content = content
        self._selection = selection
        self.isButton = isButton
        self.action = action
        self.labelWidth = labelWidth
        self.foregroundStyle = foregroundStyle
        self.textWidth = textWidth
    }
    
    var body: some View {
        Group {
            if isButton {
                Button(action: action) { contentView }.buttonStyle(.plain)
            } else {
                contentView
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch content {
        case .text(let t):
            textView(t)
        case .value(let v):
            textView("\(v)")
        case .systemImage(let name):
            imageView(name)
        case .label(let text, let name):
            labelView(text, name)
        case .none:
            EmptyView()
        }
    }
    
    private func labelView(_ text: String, _ systemName: String) -> some View {
        Label(text, systemImage: systemName)
            .font(.system(.body, design: .monospaced))
            .frame(width: labelWidth, alignment: .leading)
            .modifier(Background(selection: $selection, foregroundStyle: foregroundStyle))
    }
    
    private func imageView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .modifier(Background(selection: $selection, foregroundStyle: foregroundStyle))
    }
    
    private func textView(_ text: String) -> some View {
        Text(text)
            .frame(width: textWidth)
            .modifier(Background(selection: $selection, foregroundStyle: foregroundStyle))
    }
    
    
    private struct Background: ViewModifier {
        
        @Binding var selection: Bool
        @State private var isHovered = false
        let foregroundStyle: Color

        func body(content: Content) -> some View {
            content
                .foregroundStyle(
                    selection
                    ? foregroundStyle.opacity(0.7)
                    : foregroundStyle.opacity(0.5)
                )
                .padding()
                .background {
                    Rectangle()
                        .fill(backgroundColor)
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isHovered = hovering
                    }
                }
        }
        
        private var backgroundColor: Color {
            if selection { return Color.white.opacity(0.15) }
            if isHovered { return Color.white.opacity(0.05) }
            return Color.clear // Or a very faint base
        }
    }
}
