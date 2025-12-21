//
//  Theme.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/21/25.
//

import SwiftUI

protocol Theme {
    var primaryBackground       : Color { get }
    var secondaryBackground     : Color { get }
    var primaryForegroundStyle  : Color { get }
    var borderColor             : Color { get }
    var secondaryBorderColor    : Color { get }
}
