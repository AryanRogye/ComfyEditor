//
//  ComfyEditorViewModel.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import SwiftUI
import TextEditor

@Observable @MainActor
final class ComfyEditorViewModel {
    
    enum Screen { case none, home, editor }
    var screen: Screen = .none
    
    var settingsCoordinator: SettingsCoordinator? = nil
    var projectURL : URL?
    
    var lastSaved  : Date?
    
#if JUST_EDITOR
    var text: String = """
        
        /// TEST MOVE UP HERE
        /// SET Cursor on t and move up 2 times, make sure on t on 2nd
        func textViewDidChangeSelection(_ notification: Notification)
        //
        func textViewDidChangeSelection(_ notification: Notification)
        
        
        //
        //  TextViewCursorDelegate.swift
        //  TextEditor
        //
        //  Created by Aryan Rogye on 12/6/25.
        //
        
        import AppKit
        
        @MainActor
        protocol TextViewCursorDelegate: AnyObject {
        var isOnNewline: Bool { get }
        func textViewDidChangeSelection(_ notification: Notification)
        }
        """
#else
    var text : String = ""
#endif
    
    var font: CGFloat = 0
    var magnification: CGFloat = 0
    var isBold: Bool = false

    init() {
        self.projectURL = nil
        observeScreen()
    }
    
    func observeScreen() {
        withObservationTracking {
            _ = screen
        } onChange: {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if screen == .home {
                    print("Screen Home")
                    clearCommands()
                    text = ""
                    lastSaved = nil
                    font = 0
                    projectURL = nil
                    magnification = 0
                    isBold = false
                }
                self.observeScreen()
            }
        }
    }
    
    func assignSettingsCoordinator(_ settingsCoordinator: SettingsCoordinator) {
        self.settingsCoordinator = settingsCoordinator
    }
    
    public func saveFile() {
        guard screen == .editor else { return }
        guard let projectURL else { return }
        guard let settingsCoordinator else { return }
        
        settingsCoordinator.saveContentAsWrites(
            text,
            to: projectURL
        )
        lastSaved = .now
    }
    
    weak var commands: EditorCommands?
    
    func registerCommands(_ commands: EditorCommands) {
        self.commands = commands
    }
    
    func clearCommands() {
        self.commands = nil
    }
    
    func toggleBold() {
        guard screen == .editor else { return }
        commands?.toggleBold()
    }
    
    func increaseFont() {
        guard screen == .editor else { return }
        commands?.increaseFontOrZoomIn()
    }
    
    func decreaseFont() {
        guard screen == .editor else { return }
        commands?.decreaseFontOrZoomOut()
    }
}
