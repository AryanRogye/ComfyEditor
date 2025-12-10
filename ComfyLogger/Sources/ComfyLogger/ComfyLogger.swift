// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@MainActor
public enum ComfyLogger {
    public final class Name: @unchecked Sendable {
        public var name: String
        public var isEnabled: Bool = true
        
        private var timestamp: String {
            let df = DateFormatter()
            df.timeStyle = .medium
            df.dateStyle = .none
            return df.string(from: Date())
        }
        
        public func enable() {
            isEnabled = true
        }
        public func disable() {
            isEnabled = false
        }
        
        private var startbar: String {
            "================== \(name) START @ \(timestamp) =================="
        }
        
        private var endBar: String {
            "================== \(name) END @ \(timestamp) =================="
        }
        
        public init(_ name: String) {
            self.name = name
        }
        
        public func start() {
            guard isEnabled else { return }
            print()
            print(startbar)
        }
        
        public func insert(_ message: @autoclosure () -> Any) {
            guard isEnabled else { return }
            print("• \(message())")
        }
        
        public func end() {
            guard isEnabled else { return }
            print(endBar)
            print()
        }
    }
}
