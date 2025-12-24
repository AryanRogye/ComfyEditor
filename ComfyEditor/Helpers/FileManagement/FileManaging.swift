//
//  FileManaging.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public protocol FileManaging: Sendable {
    
    /// Allows FileManager to be testable cuz i can put it in tests with a custom implementation
    /// not isolated to any actor, can be called from any thread
    nonisolated func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]?
    ) throws
}
