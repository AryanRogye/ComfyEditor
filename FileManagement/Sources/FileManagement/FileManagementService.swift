//
//  FileManagementService.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public enum FileManagementError: Error {
    case fileCreationFailed(String)
    case direcotryCreationFailed(String)
    case writingFailed(String)
}

public actor FileManagementService: FileManagementProviding {
    
    public let fileManager : any FileManaging
    
    public init(fileManager: FileManaging) {
        self.fileManager = fileManager
    }
    
    public func content(
        at url: URL
    ) async throws -> String? {
        return try fileManager.content(at: url)
    }
    
    public func createFile(
        named name: String,
        at directory: URL
    ) async throws -> URL {
        
        let fullURL = directory.appendingPathComponent(name)
        do {
            /// Create File on a background task
            try await Task.detached(priority: .background) {
                try self.fileManager.createFile(
                    to: fullURL,
                    options: .atomic
                )
            }.value
        } catch {
            throw FileManagementError.fileCreationFailed(error.localizedDescription)
        }
        return fullURL
    }
    
    public func write(
        to url: URL,
        _ data: String
    ) async throws {
        do {
            /// Write on a background task
            try await Task.detached(priority: .background) {
                try self.fileManager.write(
                    to: url,
                    data: data,
                    atomically: true,
                    encoding: .utf8
                )
            }.value
        } catch {
            throw FileManagementError.writingFailed(error.localizedDescription)
        }
    }

    public func createDirectory(
        directory: URL,
        named name: String
    ) async throws -> URL {
        
        /// FullPath
        let fullPath = directory.appendingPathComponent(name)
        
        do {
            /// Create Directory on a background task
            try await Task.detached(priority: .background) {
                try self.fileManager.createDirectory(
                    at: fullPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }.value
        } catch {
            throw FileManagementError.direcotryCreationFailed(error.localizedDescription)
        }
        
        return fullPath
    }
    
    public func getLastModified(
        url: URL,
        isDirectory: Bool
    ) async throws -> Date? {
        
        var isDirectory: ObjCBool = isDirectory
                                ? true as ObjCBool
                                : false as ObjCBool
        guard fileManager.fileExists(
            atPath: url.path,
            isDirectory: &isDirectory
        ) else { return nil }
        
        
        let keys : Set<URLResourceKey> = [
            .contentModificationDateKey
        ]
        let resourceValues = try url.resourceValues(forKeys: keys)
        return resourceValues.contentModificationDate
    }
}
