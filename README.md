# Sigma Notes

A secure, block-based notes application built with Flutter.

## Overview

Sigma Notes is a mobile application featuring secure authentication, local data persistence,
and native platform integration. Built with Flutter and Riverpod for state management.

## 📱 Demo Gif (Check out the complete application on YT below)

### 🎥 Video Walkthrough

[**▶️ Watch the app in action**](https://youtu.be/VbMWqC9qMJg)

## Features

- **Secure Authentication**: Mock authentication with credential validation
- **Block-Based Notes**: Notion-style content blocks (text, checklists, images, audio, etc.)
- **Biometric Lock**: Secure notes with fingerprint/face authentication
- **Native Device Info**: Platform channels for accessing device information
- **Multi-User Support**: Each user has isolated note storage
- **Guest Mode**: Temporary access without account creation
- **Offline-First**: All data stored locally with SQLite

## Technical Stack

- **Framework**: Flutter
- **State Management**: Riverpod 3.x with code generation
- **Database**: SQLite (sqflite)
- **Secure Storage**: flutter_secure_storage
- **Platform Channels**: Kotlin (Android) + Swift (iOS)
- **Authentication**: Local biometrics (local_auth)

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

## Installation

1. Clone the repository:

```bash
git clone <https://github.com/Lukas-io/sigma_notes.git>
cd sigma_notes
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the application:

```bash
flutter run
```

## Test Credentials

- **Email**: `test@sigma-logic.gr`
- **Password**: `password123`

## Running Tests

Execute the test suite:

```bash
flutter test
```

This runs all unit tests for providers, repositories, and services.

## Project Structure

```
lib/
├── core/             # Core utilities (router, theme, constants)
├── models/           # Data models (Note, User, ContentModel)
├── services/         # Business logic (providers, repositories, services)
├── view/             # UI screens and widgets
└── main.dart         # App entry point

test/
├── helpers/          # Test utilities and mocks
├── models/           # Model unit tests
├── providers/        # Provider unit tests
├── repositories/     # Repository unit tests
└── services/         # Service unit tests
```

## Platform Support

- ✅ Android
- ✅ iOS

## Architecture

- **Repository Pattern**: Clean separation of data access
- **Provider Pattern**: Centralized state management with Riverpod
- **Native Channels**: Bidirectional communication with platform code

---

## Possible Improvements

### Performance Optimizations

- **Icon Management**: Compile all icons into a single PNG atlas or icon font set. This reduces
  render overhead and improves frame rates, especially on screens with multiple icons. I noticed
  jank when building screens with multiple icons, which could be resolved by using a compiled icon
  set.

- **Note Content Data Structure**: Migrate from `List<ContentModel>` to `Map<String, ContentModel>`
  where the key is the block ID. This changes update operations from O(n) to O(1), significantly
  improving performance for notes with many blocks. My computer science degree is actually helping
  here - updating a list takes O(n) time while updating a map with a key is O(1)!

- **Selective State Updates**: When editing a note, update only the modified content instead of
  rebuilding the entire state and reloading all notes from memory. This prevents unnecessary
  re-renders and database reads.

### UI/UX Enhancements

- **OpenContainer Animation**: Restructure the animations package's OpenContainer widget to better
  suit the application design and improve performance.

### Scalability

- **Lazy Loading**: Implement pagination for note lists to handle thousands of notes efficiently.
- **Content Block Indexing**: Add full-text search indices for content blocks to enable fast
  searching across all notes. Currently, search would require loading all notes into memory.
- **Background Sync**: Prepare infrastructure for future cloud sync capabilities with conflict
  resolution strategies.
- **Collaborative Editing**: Leverage the existing Collaborator model to implement real-time
  multi-user editing with operational transformation.

---

## 🎨 Design Philosophy

The app emphasizes:

- **Security First**: Biometric locks, secure storage, and protected routes
- **Mystical Aesthetic**: Dark themes, subtle animations, constellation-inspired design
- **Flexibility**: Block-based system supporting 17+ content types
- **Developer Experience**: Clean architecture, type-safe state management, comprehensive testing

---

## 📄 License

This project was created for the Sigma Logic coding assessment.
