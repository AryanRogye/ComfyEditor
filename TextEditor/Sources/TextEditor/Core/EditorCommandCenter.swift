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
public final class EditorCommandCenter {
    @ObservationIgnored public static let shared = EditorCommandCenter()
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    let textViewDelegate = TextViewDelegate()
    let magnificationDelegate = MagnificationDelegate()
    
    public var isBoldEnabled: Bool = false
    public var currentFont: CGFloat? = nil
    public var magnification: CGFloat = 4.0
    
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
    
    public func increaseFont() {
        currentEditor?.increaseFontOrZoomIn()
    }
    
    public func decreaseFont() {
        currentEditor?.decreaseFontOrZoomOut()
    }
    
    public func toggleBold() {
        currentEditor?.toggleBold()
        isBoldEnabled = currentEditor?.isCurrentlyBold() ?? false
    }
}
