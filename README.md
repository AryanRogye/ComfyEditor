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

## Vim Keybindings
Quick reference for the built-in motions and edits:

| Keys              | Mode(s)          | Action |
| ----------------- | ---------------- | ------ |
| `Esc`, `Ctrl+C`   | Any              | Return to Normal |
| `i`               | Normal           | Enter Insert |
| `v`               | Normal           | Enter Visual |
| `V` (`Shift+v`)   | Normal           | Enter Visual Line |
| `:` (`Shift+;`)   | Normal           | Enter Command mode (state only) |
| `h` `j` `k` `l`   | Normal/Visual    | Move left / down / up / right |
| `w`               | Normal/Visual    | Next word (leading) |
| `e`               | Normal/Visual    | Next word (trailing) |
| `b`               | Normal/Visual    | Previous word |
| `$` (`Shift+4`)   | Normal/Visual    | End of line |
| `_` (`Shift+-`)   | Normal/Visual    | Start of line |
| `A` (`Shift+a`)   | Normal           | Append at end of line (enters Insert) |
| `G` (`Shift+g`)   | Normal/Visual    | Bottom of file |
| `gg`              | Normal/Visual    | Top of file |
| `x`               | Normal/Visual    | Delete under cursor (Visual: delete selection) |
| `X` (`Shift+x`)   | Normal/Visual    | Delete before cursor (Visual: delete selection) |
| `p`               | Normal/Visual    | Paste (replaces selection if active) |

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
You can clone this repo and copy the `TextEditor` package directly into your app.

#### Usage
- ```swift
    // Simple usage
    ComfyTextEditor(
        text: $text,
        showScrollbar: $settingsCoordinator.showScrollbar,
        isInVimMode: $settingsCoordinator.isVimEnabled
    )
    // Advanced usage (capture editor commands, custom styling)
    ComfyTextEditor(
        text: $text,
        font: $fontSize,
        magnification: $zoomLevel,
        showScrollbar: $settingsCoordinator.showScrollbar,
        borderRadius: 8,
        isInVimMode: $settingsCoordinator.isVimEnabled,
        editorBackground: theme.editorBackground,
        editorForegroundStyle: theme.editorForegroundStyle,
        borderColor: theme.borderColor
    ) { commands in
        // commands conforms to EditorCommands; hold a weak ref if needed
        self.editorCommands = commands
    }
   ```

# Vim TODO
## Operator-Pending Deletes (`d{motion}`)
### Core Motions (MVP)
- [ ] `dw` — delete to start of next word
- [ ] `de` — delete to end of word
- [ ] `dd` — delete current line
- [ ] `D` / `d$` — delete to end of line

### Word / WORD Motions
- [ ] `dW` — delete to start of next WORD
- [ ] `dE` — delete to end of WORD

### Linewise Variants
- [ ] `d0` — delete to start of line
- [ ] `d^` — delete to first non-blank character

### Text Objects
- [ ] `diw` / `daw` — inner / around word
- [ ] `di"` / `da"` — inside / around quotes
- [ ] `di(` / `da(` — inside / around parentheses

### Find / Till Motions
- [ ] `df{char}` — delete through next `{char}`
- [ ] `dt{char}` — delete up to next `{char}`
- [ ] `dF{char}` — delete backward through `{char}`
- [ ] `dT{char}` — delete backward up to `{char}`

---

## Paste & Registers

### Paste Behavior
- [ ] `P` — paste before cursor
- [ ] Visual paste preserves yank register  
      _(replaced text stored separately so `p` repeats yank)_

### Registers
- [ ] Separate yank vs delete registers
- [ ] Numbered delete registers (`1–9`)
- [ ] Black-hole register (`"_`)
- [ ] Named registers (`a–z`)

### Insert / Command Mode
- [ ] `Ctrl+R {register}` — insert register contents
