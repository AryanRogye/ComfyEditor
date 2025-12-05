//
//  Editor.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/2/25.
//

import SwiftUI

struct Editor: NSViewControllerRepresentable {
    
    @Binding var text: String
    @Bindable var settingsCoordinator: SettingsCoordinator
    
    func makeNSViewController(context: Context) -> TextViewController {
        let viewController = TextViewController()
        return viewController
    }
    
    func updateNSViewController(_ nsViewController: TextViewController, context: Context) {
        
    }
}
