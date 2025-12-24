//
//  FileManagementService.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public actor FileManagementService: FileManagementProviding {
    
    public let fileManager : any FileManaging
    
    public init(fileManager: FileManaging) {
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

