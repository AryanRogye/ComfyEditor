//
//  VimEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import Combine
import Foundation

@MainActor
class VimEngine: ObservableObject {
    
    @Published var isInVimMode = false
    @Published var state : VimState = .normal

    var cancellables: Set<AnyCancellable> = []
    
    init() {
    }
}
