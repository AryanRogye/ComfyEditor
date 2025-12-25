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
    
    var settingsCoordinator: SettingsCoordinator? = nil
    var projectURL : URL?
    
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
    var text : String = "" {
        didSet {
            saveFile()
        }
    }
#endif
    
    var font: CGFloat = 0
    var magnification: CGFloat = 0
    var isBold: Bool = false

    init() {
        self.projectURL = nil
    }
    
    func assignSettingsCoordinator(_ settingsCoordinator: SettingsCoordinator) {
        self.settingsCoordinator = settingsCoordinator
    }
    
    func saveFile() {
        guard let projectURL else { return }
        guard let settingsCoordinator else { return }
        
        settingsCoordinator.saveContentAsWrites(
            text,
            to: projectURL
        )
    }
    
    weak var commands: EditorCommands?
    
    func registerCommands(_ commands: EditorCommands) {
        self.commands = commands
    }
    
    func clearCommands() {
        self.commands = nil
    }
    
    func toggleBold() {
        commands?.toggleBold()
    }
    
    func increaseFont() {
        commands?.increaseFontOrZoomIn()
    }
    
    func decreaseFont() {
        commands?.decreaseFontOrZoomOut()
    }
}
