# Sigma Notes

A secure notes application built with Flutter for the Sigma Logic coding assessment.

## Overview

Sigma Notes is a simple, secure mobile application that allows users to authenticate and manage their personal notes. The app demonstrates core Flutter development skills including authentication, state management, and native platform integration.

## Features

- **User Authentication**: Secure login with credential validation
- **Notes Management**: View and manage a list of personal notes
- **Device Information**: Access native device details through platform channels
- **Protected Routes**: Secure navigation ensuring authenticated access only

## Project Structure

The application consists of three main screens:
1. **Login Screen**: User authentication with email and password
2. **Notes Screen**: Display list of notes (accessible after login)
3. **Device Info Screen**: Shows native device information (accessible after login)

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run the app using `flutter run`

### Test Credentials
- Email: `test@sigma-logic.gr`
- Password: `password123`

## Running Tests

Execute the test suite with:
```bash
flutter test
```

## Platform Support

- ✅ Android
- ✅ iOS