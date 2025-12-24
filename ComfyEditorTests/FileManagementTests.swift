//
//  ComfyEditorTests.swift
//  ComfyEditorTests
//
//  Created by Aryan Rogye on 12/23/25.
//

import Testing
import Foundation
import ComfyEditor

class FakeFileManager : FileManaging, @unchecked Sendable {
    
    public var createdDirectories: [URL] = []
    
    public func createDirectory(
        at url: URL,
        /// Ignore
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]? = nil
    ) throws {
        createdDirectories.append(url)
    }
}

private extension FileManaging {
    static func DefaultDir() -> URL {
        FileManager.default.temporaryDirectory
    }
}


@MainActor
struct FileManagementTests {
    
    let fileManagement : FileManagementProviding
    let fakeFileManager = FakeFileManager()
    let dateFormatter : DateFormatter
    let timeFormatter : DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd" // customize as needed
        
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = .current
        timeFormatter.dateFormat = "HH:mm:ss" // 24h; use "h:mm a" for 12h
        fileManagement = FileManagementService(fileManager: fakeFileManager)
    }
    
    @Test
    func testCreateDefaultProjectDirectory() async throws {
        let name = "Untitled-\(dateFormatter.string(from: .now))-\(timeFormatter.string(from: .now))"
        let base = FakeFileManager.DefaultDir()
        
        try await fileManagement.createDirectory(directory: base, named: name)
        
        #expect(fakeFileManager.createdDirectories.count == 1)
        
        let expected = base.appendingPathComponent(name)
        #expect(fakeFileManager.createdDirectories.first == expected)
    }
}
