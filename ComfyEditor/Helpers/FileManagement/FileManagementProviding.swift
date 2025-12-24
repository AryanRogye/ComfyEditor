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
    ) async throws
}
