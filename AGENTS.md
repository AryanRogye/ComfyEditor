# Repository Guidelines

## Project Structure & Module Organization
- `ComfyEditor/`: macOS app sources. `App/` hosts entry points and menu bar, `Coordinators/` drives shared state (themes, settings), `Helpers/` contains window/titlebar utilities, `Views/` holds SwiftUI screens, and `Extensions/` collects cross-cutting helpers. Assets live in `Assets.xcassets`.
- Local Swift packages live at the root. `TextEditor/` contains the reusable editor module (`Sources/`, `Tests/`), `LocalShortcuts/` provides keyboard handling, and `ComfyLogger/` centralizes logging utilities. Open `ComfyEditor.xcworkspace` (or `.xcodeproj`) to work across app and packages.

## Build, Test, and Development Commands
- `./run.sh`: Builds scheme `ComfyEditor_JUST_EDITOR`, moves the produced `ComfyEditor.app` to the repo root, and launches it. Uses a local `DerivedData` directory that is cleaned afterward.
- `xcodebuild -scheme ComfyEditor_JUST_EDITOR -derivedDataPath DerivedData build`: Manual build equivalent without opening the app.
- `cd TextEditor && swift test`: Run package tests for the editor module.
- Use Xcode for interactive development; select the appropriate scheme before running or profiling.

## Coding Style & Naming Conventions
- Swift 6 with 4-space indentation; prefer `guard` + early returns. Avoid optionals in new code—model data as non-optional with sensible defaults, throw/return errors for invalid states, and convert any external optionals to concrete values at the boundary (no force-unwraps).
- Types are `PascalCase`; functions/properties `camelCase`; enum cases lowerCamel. Keep SwiftUI view logic in `Views/`, window chrome logic in `Helpers/`, and shared coordination/state in `Coordinators/`. Keep UI touches on the main actor (`@MainActor` or `DispatchQueue.main.async`).

## Testing Guidelines
- Unit tests live in `TextEditor/Tests/TextEditorTests`; mirror source file names with a `*Tests` suffix and keep cases focused on text-editing behaviors.
- Run `swift test` before submitting editor changes. App-level UI is exercised manually; include reproduction and validation steps when altering window/titlebar behavior or menu interactions.

## Commit & Pull Request Guidelines
- Follow existing history: concise, action-oriented subjects (e.g., “Fixing Traffic Light Issue when out of focus”). Keep commits scoped and present-tense.
- PRs should describe the change, list verification (`./run.sh`, `swift test`), attach screenshots/GIFs for user-facing updates, and link issues/tasks. Call out risk areas (window chrome, theme persistence, keyboard handling) and any follow-up work needed.
