//
//  ComfyEditorViewModel.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import SwiftUI

@Observable @MainActor
final class ComfyEditorViewModel {
    var projectURL : URL?
    
    init() {
        self.projectURL = nil
    }
}
