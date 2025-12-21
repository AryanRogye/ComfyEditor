//
//  Themes.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

// MARK: - Tokyo Theme
final class TokyoTheme: Theme {
    var primaryBackground: Color = Color(hex: "#16171c")
    var secondaryBackground: Color = Color(hex: "#1b1b25")
    var primaryForegroundStyle: Color = Color.white
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
}

// MARK: - Dracula Theme
final class DraculaTheme: Theme {
    var primaryBackground: Color = Color(hex: "#282a36")
    var secondaryBackground: Color = Color(hex: "#1e1f29")
    var primaryForegroundStyle: Color = Color(hex: "#f8f8f2")
    var borderColor: Color = .gray.opacity(0.3)
    var secondaryBorderColor: Color = .gray.opacity(0.2)
}

// MARK: - Assign ColorTheme
extension ColorTheme {
    static var tokyoNight = ColorTheme(id: "tokyoNight", "Tokyo Night", theme: TokyoTheme())
    static var draculaTheme = ColorTheme(id: "draculaTheme", "Dracula", theme: DraculaTheme())
}
