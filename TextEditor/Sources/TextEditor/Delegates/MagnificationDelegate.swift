//
//  MagnificationDelegate.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import AppKit
import Combine

final class MagnificationDelegate: NSObject, ScrollViewMagnificationDelegate, ObservableObject {
    
    @Published var magnification: CGFloat = 4.0
    
    func scrollView(_ scrollView: NSScrollView, didChangeMagnification magnification: CGFloat) {
        self.magnification = magnification
    }
}
