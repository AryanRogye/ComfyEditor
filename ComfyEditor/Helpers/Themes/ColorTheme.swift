//
//  ColorTheme.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

struct ColorTheme {
    let id: String
    var name  : String
    var theme : Theme
    
    init(id: String, _ name: String, theme: Theme) {
        self.id    = id
        self.name  = name
        self.theme = theme
    }
}
