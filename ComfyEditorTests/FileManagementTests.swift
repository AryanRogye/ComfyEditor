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
    var files: Set<URL> = []
    var contents: [URL: String] = [:]
    
    public func createDirectory(
        at url: URL,
        /// Ignore
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]? = nil
    ) throws {
        createdDirectories.append(url)
    }
    
    func createFile(
        to path: URL,
        options: Data.WritingOptions
    ) throws {
        files.insert(path)
        contents[path] = ""
    }
    
    func write(to url: URL, data: String, atomically: Bool, encoding: String.Encoding) throws {
        guard files.contains(url) else { throw FileManagementError.writingFailed("File doesn't exist in fake") }
        contents[url] = data
    }
    
    func content(at url: URL) throws -> String? {
        contents[url]
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
    func testCreateDirectory() async throws {
        let name = "Untitled-\(dateFormatter.string(from: .now))-\(timeFormatter.string(from: .now))"
        let base = FakeFileManager.DefaultDir()
        
        let url = try await fileManagement.createDirectory(directory: base, named: name)
        
        #expect(fakeFileManager.createdDirectories.count == 1)
        
        let expected = base.appendingPathComponent(name)
        #expect(url == expected)
    }
    
    @Test
    func testCreateFile() async throws {
        let name = "Untitled-\(dateFormatter.string(from: .now))-\(timeFormatter.string(from: .now))"
        let base = FakeFileManager.DefaultDir()
        
        let dir = try await fileManagement.createDirectory(directory: base, named: name)
        
        let url = try await fileManagement.createFile(
            named: "content",
            at: dir
        )
        #expect(url == dir.appendingPathComponent("content"))
    }
    
    @Test
    func testWriteToFile() async throws {
        let name = "Untitled-\(dateFormatter.string(from: .now))-\(timeFormatter.string(from: .now))"
        let base = FakeFileManager.DefaultDir()
        
        let dir = try await fileManagement.createDirectory(directory: base, named: name)
        
        let url = try await fileManagement.createFile(
            named: "content",
            at: dir
        )
        let CONTENT_SET = "HEY HOW ARE YOU DOING"
        try await fileManagement.write(to: url, CONTENT_SET)
        let content = try await fileManagement.content(at: url)
        
        #expect(content == CONTENT_SET)
    }
}
