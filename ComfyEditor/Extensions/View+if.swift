//
//  View+if.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}
