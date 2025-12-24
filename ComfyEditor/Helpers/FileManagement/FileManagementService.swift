//
//  FileManagementService.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public actor FileManagementService: FileManagementProviding {
    
    /// Safe to call from this actors thread because we use FileManager.default and
    /// FileManager.default according to apple "can be called from multiple threads safely"
    /// `https://developer.apple.com/documentation/foundation/filemanager?language=objc#Threading-considerations:~:text=Threading%20considerations,initiate%20your%20operations.`
    /// Making sure when we call it, we call it using await
    public nonisolated let fileManager : any FileManaging & Sendable
    
    public init(fileManager: FileManaging & Sendable) {
        self.fileManager = fileManager
    }
    
    public func createDirectory(
        directory: URL,
        named name: String
    ) async throws {
        
        /// FullPath
        let fullPath = directory.appendingPathComponent(name)
        
        try self.fileManager.createDirectory(
            at: fullPath,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}

