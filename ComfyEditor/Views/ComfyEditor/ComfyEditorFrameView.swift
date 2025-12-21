//
//  ComfyEditorFrameView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct ComfyEditorFrameView<TopBar: View, Content: View>: View {
    
    var backgroundColor : Color
    var borderColor     : Color
    
    var topBar : TopBar
    var content: Content
    
    init(
        backgroundColor      : Color,
        borderColor          : Color,
        @ViewBuilder content : @escaping () -> Content,
        @ViewBuilder topBar  : @escaping () -> TopBar,
    ) {
        self.topBar  = topBar()
        self.content = content()
        self.backgroundColor = backgroundColor
        self.borderColor     = borderColor
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                content
            }
            /// Background Color Of Frame
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            /// Border Color
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
