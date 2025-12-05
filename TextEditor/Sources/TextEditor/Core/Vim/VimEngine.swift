//
//  VimEngine.swift
//  TextEditor
//
//  Created by Aryan Rogye on 12/5/25.
//

import Combine

class VimEngine: ObservableObject {
    
    @Published var isInVimMode = false
    @Published var commandLine = ""
    @Published var state : VimState = .normal

    var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeIsInVimMode()
    }
}

extension VimEngine {
    /// Changes command line based on what `isinVimMode` is
    private func observeIsInVimMode() {
        $isInVimMode
            .sink { [weak self] inVimMode in
                guard let self else { return }
                if inVimMode {
                    self.commandLine = ""
                } else {
                    self.commandLine = "Vim Mode Not Enabled"
                }
            }
            .store(in: &cancellables)
    }
}
