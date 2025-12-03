//
//  KeybindView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI
import KeyboardShortcuts

struct KeybindView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Bold")
                Spacer()
                KeyboardShortcuts.Recorder(for: .toggleBold)
            }.padding(.horizontal, 8)
            HStack {
                Text("Increase Font/Zoom In")
                Spacer()
                KeyboardShortcuts.Recorder(for: .increaseFont)
            }.padding(.horizontal, 8)
            HStack {
                Text("Decrease Font/Zoom out")
                Spacer()
                KeyboardShortcuts.Recorder(for: .decreaseFont)
            }.padding(.horizontal, 8)
        }
        .frame(width: 400, height: 400)
    }
}
