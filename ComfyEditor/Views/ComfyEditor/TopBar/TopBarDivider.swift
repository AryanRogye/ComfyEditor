//
//  TopBarDivider.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

struct TopBarDivider: View {
    
    var color : Color
    var height: CGFloat
    
    init(_ color: Color, _ height: CGFloat) {
        self.color  = color
        self.height = height
    }
    
    var body: some View {
        VStack{}
            .frame(maxWidth: 1, maxHeight: height)
            .border(color)
    }
}
