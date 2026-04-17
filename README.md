<h1 align="center">Kata Golla by 7</h1>

<p align="center">
	A modern Flutter Tic Tac Toe app with real-time Firestore match history, polished UI, and Provider-based state management.
</p>

<p align="center">
	<img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
	<img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
	<img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firestore" />
	<img src="https://img.shields.io/badge/State_Management-Provider-5C6BC0" alt="Provider" />
</p>

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Architecture](#project-architecture)
- [Quick Start](#quick-start)
- [Firebase Setup](#firebase-setup)
- [Run Commands](#run-commands)
- [Validation Checklist](#validation-checklist)
- [Troubleshooting](#troubleshooting)

---

## Features

| Area | Highlights |
|---|---|
| Game Setup | Player name validation and smooth start flow |
| Gameplay | Interactive 3x3 board with win/tie detection |
| Timer | 10-second turn timer, timeout gives win to opponent |
| Persistence | Match results saved to Cloud Firestore |
| History | Real-time match list with win-rate and total-games stats |
| UX | Light/Dark thematic screens with custom typography |
| Platforms | Android emulator + iOS simulator ready |

---

## Tech Stack

- Flutter (Material 3)
- Dart
- Provider
- Firebase Core
- Cloud Firestore
- Google Fonts
- Intl

---

## Project Architecture

```text
lib/
	main.dart
	firebase_options.dart
	models/
		match_model.dart
	providers/
		game_provider.dart
		history_provider.dart
	screens/
		setup_screen.dart
		game_screen.dart
		history_screen.dart
	services/
		firestore_service.dart
	theme/
		app_theme.dart
	widgets/
		game_board.dart
		match_tile.dart
```

---

## Quick Start

### Prerequisites

- Flutter SDK installed
- Android SDK + emulator
- Xcode + iOS simulator
- CocoaPods
- Firebase CLI
- FlutterFire CLI

### Install

```bash
flutter pub get
```

If needed after dependency changes:

```bash
flutter clean
flutter pub get
```

---

## Firebase Setup

1. Login

```bash
firebase login
```

2. Configure FlutterFire

```bash
flutterfire configure \
	--project=radiant-toe \
	--platforms=android,ios \
	--android-package-name=com.example.tictactoe_p002 \
	--ios-bundle-id=com.example.tictactoeP002 \
	--out=lib/firebase_options.dart \
	--yes \
	--overwrite-firebase-options
```

3. In Firebase Console

- Enable Cloud Firestore API
- Create Firestore database `(default)` in Native mode
- Use development rules while testing

```txt
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		match /{document=**} {
			allow read, write: if true;
		}
	}
}
```

---

## Run Commands

### Android

```bash
flutter run -d emulator-5554
```

### iOS

```bash
flutter run -d 8CEB9BBF-5C7E-4085-B262-6961A5B4F01D
```

### Interactive device picker

```bash
flutter run
```

---

## Validation Checklist

- `flutter analyze` passes
- `flutter test` passes
- Android launch successful
- iOS launch successful
- Finish a match and confirm Firestore document appears under `matches`
- History screen updates in real-time

---

## Troubleshooting

### iOS Pod version mismatch

```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### Firestore permission denied

- Confirm Firestore database exists
- Confirm rules allow your current development access
- Verify FlutterFire project matches your active Firebase project

### Android install/storage issue

```bash
adb uninstall com.example.tictactoe_p002
flutter run -d emulator-5554
```

---

## Project Context

This repository is maintained as an academic/coursework final project.
