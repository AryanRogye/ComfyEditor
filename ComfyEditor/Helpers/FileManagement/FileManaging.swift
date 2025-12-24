//
//  FileManaging.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public protocol FileManaging: Sendable {
    
    /// Allows FileManager to be testable cuz i can put it in tests with a custom implementation
    /// `FileManager.default` is is thread safe, so that means that it can be set as nonisolated
    nonisolated func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]?
    ) throws
}
