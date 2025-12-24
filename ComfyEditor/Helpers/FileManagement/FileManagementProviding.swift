//
//  FileManagementProviding.swift
//  ComfyEditor
//
//  Created by Aryan Rogye on 12/23/25.
//

import Foundation

public protocol FileManagementProviding {
    
    func createDirectory(
        directory: URL,
        named name: String
    ) async throws -> URL
    
    @discardableResult
    func createFile(
        named name: String,
        at directory: URL
    ) async throws -> URL
    
    func write(
        to url: URL,
        _ data: String
    ) async throws
    
    func content(
        at url: URL
    ) async throws -> String?
    
}
