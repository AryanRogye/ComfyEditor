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

    init() {
        self.projectURL = nil
    }
}
