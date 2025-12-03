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
    
    var body: some View {
        VStack(spacing: 0) {
            ComfyEditorBar()
            Editor(text: $source)
                .frame(minWidth: 600, minHeight: 400)
        }
    }
}
