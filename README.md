# ComfyEditor

Building a text editor has always been something i've always wanted to do, since i've learned programming
before swift, always attempted to do this in C, C++, etc, but after learning the apple ecosystem, i've
been vibing with building out a editor with `NSTextView`

This project is an exploration of editor internals, input handling, and Vim-style navigation on macOS.

<img width="1920" height="720" alt="Screenshot 2025-12-07 at 5 20 59 PM" src="https://github.com/user-attachments/assets/6ed76aba-37a7-49b7-a35b-d94a95fe41a3" />

> Lol does not support syntax highlighting but u can paste in xcode code and it'll look like it has syntax colors cuz it keeps attributed text intact

## Notes
- Vim-style cursor motion is implemented using a custom finite-state approach
  - **HOLY FUCK** didnt know the struggle for this
- Cursor behavior is line-aware and built directly on NSTextView
- This is very much an exploration of editor internals, not a polished replacement (yet)

## Built Local Packages

### LocalShortcuts
A local package for in-app key handling.
- Package for "key" handling
- Inspired by [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
  - But this was global, i needed to scan `NSEvent` and map to a `Key`
- Also Supports Same Style Syntax
- ```swift
    extension LocalShortcuts.Name {
        /// Toggle Bold
        static let toggleBold = LocalShortcuts.Name(
            "ToggleBold",
            .init(modifier: [.command], keys: [.b])
        )
        /// Increase Font
        static let increaseFont = LocalShortcuts.Name(
            "IncreaseFont",
            .init(modifier: [.command], keys: [.equal])
        )
        /// Decrease Font
        static let decreaseFont = LocalShortcuts.Name(
            "IncreaseFont",
            .init(modifier: [.command], keys: [.minus])
        )
    }
    /// Registering Keys IN APP
    LocalShortcuts.Name.onKeyDown(for: .toggleBold) {
        EditorCommandCenter.shared.toggleBold()
    }
    LocalShortcuts.Name.onKeyDown(for: .increaseFont) {
        EditorCommandCenter.shared.increaseFont()
    }
    LocalShortcuts.Name.onKeyDown(for: .decreaseFont) {
        EditorCommandCenter.shared.decreaseFont()
    }
    /// Same Style Recorder
    LocalShortcuts.LocalShortcutsRecorder(for: .increaseFont)
  ```

### TextEditor
My Implementation of the texteditor
- ```swift
    ComfyTextEditor(
        text: $text,
        showScrollbar: $settingsCoordinator.showScrollbar,
        isInVimMode: $settingsCoordinator.isVimEnabled
    )
    /// Also Supports
    ComfyTextEditor(
        text: $text,
        showScrollbar: $settingsCoordinator.showScrollbar
    )
   ```

