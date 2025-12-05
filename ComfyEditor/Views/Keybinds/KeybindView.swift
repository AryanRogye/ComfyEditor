//
//  KeybindView.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI
import KeyboardShortcuts
import LocalShortcuts

struct KeybindView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Bold")
                Spacer()
                LocalShortcuts.LocalShortcutsRecorder(for: .toggleBold)
            }.padding(.horizontal, 8)
            HStack {
                Text("Increase Font/Zoom In")
                Spacer()
                LocalShortcuts.LocalShortcutsRecorder(for: .increaseFont)
            }.padding(.horizontal, 8)
            HStack {
                Text("Decrease Font/Zoom out")
                Spacer()
                LocalShortcuts.LocalShortcutsRecorder(for: .decreaseFont)
            }.padding(.horizontal, 8)
        }
        .frame(width: 400, height: 400)
    }
}
