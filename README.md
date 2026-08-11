# Task Board

A responsive cross-platform Flutter Task Board built from a single codebase. The interface adapts intentionally across phone, tablet, and desktop widths rather than stretching one mobile layout to every screen size.

## Features

- Add a task with title and optional note
- Mark tasks complete or incomplete
- Delete tasks with confirmation
- Filter tasks: All / Active / Completed
- Local persistence across app restarts
- Responsive and adaptive UI
- Light, dark, and system appearance support

## Adaptive Experience

Layout decisions are based on available width (breakpoints), not the host operating system.

**Compact (phone)** — touch-first layout with a summary banner, filter controls, scrollable task list, FAB, and bottom-sheet task creation.

**Medium (large phone / small tablet)** — centered content column, horizontal overview statistics, dialog-based task creation, and FAB.

**Expanded / Large (desktop and wide web)** — two-pane workspace with a persistent Create Task panel and Overview statistics on the left, and the primary Tasks workspace on the right.

## Architecture

```
Presentation (Riverpod)
        ↓
TaskRepository
        ↓
TaskLocalDataSource
        ↓
SharedPreferencesAsync + JSON
```

- One shared business layer across all platforms
- Repository abstraction keeps persistence replaceable without rewriting UI logic
- Filtered tasks and statistics are derived state from the loaded task list

## Project Structure

```
lib/
  app/                 # App shell, theme, responsive breakpoints
  core/constants/      # App-wide strings and constants
  features/tasks/
    data/              # Local data source and repository implementation
    domain/            # Task model, filters, repository interface
    presentation/      # Controllers, providers, layouts, widgets

test/
  features/tasks/      # Domain, data, controller, and UI tests
  helpers/             # Shared test app builders

screenshots/           # Reference screenshots for submission review
```

## Tech Stack

- Flutter
- Dart
- Riverpod
- SharedPreferencesAsync (`shared_preferences`)
- uuid
- Material 3

## Tested Platforms

**Verified during development**

- iOS Simulator (iPhone 16 Pro Max, iOS 18.4)
- macOS
- Web / Chrome

**Project contains Flutter target support for**

- Android
- iOS
- macOS
- Windows
- Linux
- Web

Windows, Linux, and Android were not manually runtime-tested in this submission environment.

## Getting Started

### Prerequisites

- A stable Flutter SDK (3.x)
- Platform toolchain for your target (Xcode for iOS/macOS, Chrome for web, etc.)

### Setup and run

```bash
flutter pub get
flutter run
```

Examples:

```bash
flutter run -d macos
flutter run -d chrome
```

For iOS, list devices and run against an available simulator or device:

```bash
flutter devices
flutter run -d <device-id>
```

## Tests

```bash
flutter analyze
flutter test
```

The suite covers model serialization, filtering, local persistence, task controller behavior, responsive layout selection, mobile and desktop UI flows, and long-content layout stability.

## Local Persistence

Tasks are stored locally as a JSON-encoded list in `SharedPreferencesAsync`. No backend or API is required for the core assessment functionality. Malformed stored data is handled safely by returning an empty task list.

## Bonus / Additional Work

- Light / dark / system appearance selector
- Branded splash screen (in-app and native/web launch)
- Widget, flow, and golden screenshot tests
- Repository-based offline-friendly architecture
- Delete confirmation dialog
- Centralized user-facing strings

## Assumptions / Scope

- Authentication was intentionally omitted
- Backend integration was intentionally omitted
- The task model focuses on assessment requirements (title, optional note, completion state)
- Active filter selection is session state and is not persisted
- Unnecessary feature expansion was avoided to keep the codebase reviewable
