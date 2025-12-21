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
}

// MARK: - Tokyo Theme
final class TokyoTheme: Theme {
    var primaryBackground: Color = Color(hex: "#16171c")
    var secondaryBackground: Color = Color(hex: "#1b1b25")
    var primaryForegroundStyle: Color = Color(hex: "#C0CAF5")
    var secondaryForegroundStyle: Color = Color(hex: "#9D7CD8")
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
}

// MARK: - Dracula Theme
final class DraculaTheme: Theme {
    var primaryBackground: Color = Color(hex: "#282a36")
    var secondaryBackground: Color = Color(hex: "#1e1f29")
    var primaryForegroundStyle: Color = Color(hex: "#F8F8F2")
    var secondaryForegroundStyle: Color = Color(hex: "#BD93F9")
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
}

// MARK: - Gruvbox Theme
final class GruvboxTheme: Theme {
    var primaryBackground: Color = Color(hex: "#1d2021")   // bg0 hard
    var secondaryBackground: Color = Color(hex: "#282828") // bg1
    
    var primaryForegroundStyle: Color = Color(hex: "#ebdbb2") // fg
    var secondaryForegroundStyle: Color = Color(hex: "#fe8019") // orange

    var borderColor: Color = Color(hex: "#3c3836")         // bg3
    var secondaryBorderColor: Color = Color(hex: "#504945") // bg4
}

// MARK: - Assign ColorTheme
extension ColorTheme {
    static var light        = ColorTheme(id: "lightTheme", "Light Theme", theme: LightTheme())
    static var tokyoNight   = ColorTheme(id: "tokyoNight", "Tokyo Night", theme: TokyoTheme())
    static var draculaTheme = ColorTheme(id: "draculaTheme", "Dracula", theme: DraculaTheme())
    static var gruvBoxHard  = ColorTheme(id: "gruvBoxHard", "Gruvbox Hard", theme: GruvboxTheme())
}
