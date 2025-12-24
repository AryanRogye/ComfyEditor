//
//  FileManaging.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public protocol FileManaging: Sendable {
    
    /// Replicates
    /// - (BOOL) createDirectoryAtURL:(NSURL *) url
    ///   withIntermediateDirectories:(BOOL) createIntermediates
    ///                    attributes:(NSDictionary<NSString *,id> *) attributes
    ///                         error:(NSError * *) error;
    /// From `FileManager.default`
    nonisolated func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]?
    ) throws
    
    nonisolated func createFile(
        to path: URL,
        options: Data.WritingOptions
    ) throws
    
    nonisolated func write(
        to url: URL,
        data: String,
        atomically: Bool,
        encoding: String.Encoding
    ) throws
    
    nonisolated func content(
        at url: URL
    ) throws -> String?
}
