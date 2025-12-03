//
//  EditorCommandCenter.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import Foundation
import AppKit
import Combine

@Observable @MainActor
final class EditorCommandCenter {
    @ObservationIgnored static let shared = EditorCommandCenter()
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    let textViewDelegate = TextViewDelegate()
    let magnificationDelegate = MagnificationDelegate()
    
    var isBoldEnabled: Bool = false
    var currentFont: CGFloat? = nil
    var magnification: CGFloat = 4.0
    
    init() {
        textViewDelegate.$font
            .sink { [weak self] font in
                guard let self else { return }
                self.currentFont = font?.pointSize
            }
            .store(in: &cancellables)
        magnificationDelegate.$magnification
            .sink { [weak self] magnification in
                guard let self else { return }
                self.magnification = magnification
            }
            .store(in: &cancellables)
    }
    
    weak var currentEditor : TextViewController?
    
    func increaseFont() {
        currentEditor?.increaseFontOrZoomIn()
    }
    
    func decreaseFont() {
        currentEditor?.decreaseFontOrZoomOut()
    }
    
    func toggleBold() {
        currentEditor?.toggleBold()
        isBoldEnabled = currentEditor?.isCurrentlyBold() ?? false
    }
}
