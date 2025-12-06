//
//  VimStatus.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import SwiftUI

struct VimStatus: View {
    
    @ObservedObject var vimEngine: VimEngine
    
    /// This is dependent on if vim is enabled or not
    var opacity: CGFloat {
        vimEngine.isInVimMode ? 0.8 : 0
    }
    var shouldShow: Bool {
        vimEngine.isInVimMode
    }
    var opacityBackground: CGFloat {
        vimEngine.isInVimMode ? 0.3 : 0
    }
    var color: Color {
        switch vimEngine.state {
        case .normal: .gray
        case .insert: .purple
        case .visual: .cyan
        }
    }
    
    var body: some View {
        Text(vimEngine.state.rawValue)
            .opacity(opacity)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(opacityBackground))
            }
    }
}




#Preview {
    @Previewable @StateObject var vimEngine1 = VimEngine()
    @Previewable @StateObject var vimEngine2 = VimEngine()
    @Previewable @StateObject var vimEngine3 = VimEngine()
    @Previewable @StateObject var vimEngine4 = VimEngine()
    
    let test: (VimEngine) -> some View = { engine in
        HStack {
            VimStatus(vimEngine: engine)
            Spacer()
        }
        .border(Color.black)
    }
    
    VStack {
        VStack(spacing: 8) {
            test(vimEngine1)
                .task {
                    vimEngine1.isInVimMode = false
                }
            test(vimEngine2)
                .task {
                    vimEngine2.isInVimMode = true
                    vimEngine2.state = .normal
                }
            test(vimEngine3)
                .task {
                    vimEngine3.isInVimMode = true
                    vimEngine3.state = .insert
                }
            test(vimEngine4)
                .task {
                    vimEngine4.isInVimMode = true
                    vimEngine4.state = .visual
                }
        }
        .frame(width: 100, height: 120)
    }
}
