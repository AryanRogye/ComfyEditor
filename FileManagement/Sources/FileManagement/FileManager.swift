//
//  FileManager.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

extension FileManager : FileManaging, @unchecked @retroactive Sendable {
    
    public nonisolated func createFile(
        to path: URL,
        options: Data.WritingOptions = []
    ) throws {
        try Data().write(
            to: path,
            options: options
        )
    }
    
    public nonisolated func write(
        to url: URL,
        data: String,
        atomically: Bool,
        encoding: String.Encoding
    ) throws {
        try data.write(
            to: url,
            atomically: atomically,
            encoding: encoding
        )
    }
    
    public nonisolated func content(
        at url: URL
    ) throws -> String? {
        let content = try String(contentsOf: url, encoding: .utf8)
        return content
    }
}
