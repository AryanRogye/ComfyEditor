//
//  Themes.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

final class LightTheme: Theme {
    var primaryBackground: Color = .white
    var secondaryBackground: Color = Color(white: 0.95)
    var primaryForegroundStyle: Color = .black
    var secondaryForegroundStyle: Color = Color(white: 0.6)
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
    
    var syntaxKeyword               : Color = Color(hex: "#9B2393")
    var syntaxString                : Color = Color(hex: "#C41A16")
    var syntaxNumber                : Color = Color(hex: "#1C00CF")
    var syntaxComment               : Color = Color(hex: "#008000")
    var syntaxJsonKey               : Color = Color(hex: "#326D74")
}

// MARK: - Tokyo Theme
final class TokyoTheme: Theme {
    var primaryBackground: Color = Color(hex: "#16171c")
    var secondaryBackground: Color = Color(hex: "#1b1b25")
    var primaryForegroundStyle: Color = Color(hex: "#C0CAF5")
    var secondaryForegroundStyle: Color = Color(hex: "#9D7CD8")
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
    
    var syntaxKeyword               : Color = Color(hex: "#BB9AF7")
    var syntaxString                : Color = Color(hex: "#9ECE6A")
    var syntaxNumber                : Color = Color(hex: "#FF9E64")
    var syntaxComment               : Color = Color(hex: "#565F89")
    var syntaxJsonKey               : Color = Color(hex: "#7AA2F7")
}

// MARK: - Dracula Theme
final class DraculaTheme: Theme {
    var primaryBackground: Color = Color(hex: "#282a36")
    var secondaryBackground: Color = Color(hex: "#1e1f29")
    var primaryForegroundStyle: Color = Color(hex: "#F8F8F2")
    var secondaryForegroundStyle: Color = Color(hex: "#BD93F9")
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
    
    var syntaxKeyword               : Color = Color(hex: "#FF79C6")
    var syntaxString                : Color = Color(hex: "#F1FA8C")
    var syntaxNumber                : Color = Color(hex: "#BD93F9")
    var syntaxComment               : Color = Color(hex: "#6272A4")
    var syntaxJsonKey               : Color = Color(hex: "#8BE9FD")
}

// MARK: - Gruvbox Theme
final class GruvboxTheme: Theme {
    var primaryBackground: Color = Color(hex: "#1d2021")   // bg0 hard
    var secondaryBackground: Color = Color(hex: "#282828") // bg1
    
    var primaryForegroundStyle: Color = Color(hex: "#ebdbb2") // fg
    var secondaryForegroundStyle: Color = Color(hex: "#fe8019") // orange
    
    var borderColor: Color = Color(hex: "#3c3836")         // bg3
    var secondaryBorderColor: Color = Color(hex: "#504945") // bg4
    
    var syntaxKeyword               : Color = Color(hex: "#FB4934")
    var syntaxString                : Color = Color(hex: "#B8BB26")
    var syntaxNumber                : Color = Color(hex: "#D3869B")
    var syntaxComment               : Color = Color(hex: "#928374")
    var syntaxJsonKey               : Color = Color(hex: "#83A598")
}

// MARK: - Assign ColorTheme
extension ColorTheme {
    static var light        = ColorTheme(id: "lightTheme", "Light Theme", theme: LightTheme())
    static var tokyoNight   = ColorTheme(id: "tokyoNight", "Tokyo Night", theme: TokyoTheme())
    static var draculaTheme = ColorTheme(id: "draculaTheme", "Dracula", theme: DraculaTheme())
    static var gruvBoxHard  = ColorTheme(id: "gruvBoxHard", "Gruvbox Hard", theme: GruvboxTheme())
}
