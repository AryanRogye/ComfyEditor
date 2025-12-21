//
//  TopBarDivider.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct TopBarDivider: View {
    
    var height: CGFloat
    
    init(_ height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        VStack{}
            .frame(maxWidth: 1, maxHeight: height)
            .border(.white.opacity(0.25))
    }
}
