# 時鐘 App (Clock App)

A Flutter-based clock application with four main features: World Clock, Alarm, Timer, and Stopwatch.

## Features

### 世界時鐘 (World Clock)
- Displays real-time clocks for multiple cities around the world
- Supports up to 5 clocks simultaneously
- Choose from 15 preset cities across different time zones (e.g., Tokyo, Seoul, London, Los Angeles)
- Delete individual clocks with the trash icon

### 鬧鐘 (Alarm)
- Create multiple alarms with custom times
- Select which days of the week each alarm is active (Monday–Sunday)
- Enable or disable each alarm individually with a toggle switch
- Edit or delete existing alarms

### 計時器 (Timer)
- Set a countdown in increments of 10 seconds
- Start, pause, and stop controls
- Displays an alert dialog when the countdown reaches zero

### 碼表 (Stopwatch)
- Measures elapsed time with 0.1-second precision
- Start, stop, and reset controls

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.9.2
- Dart SDK ^3.9.2

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/AndyLin7533/APP1_C112151135_final.git
   cd APP1_C112151135_final
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Supported Platforms

- Android
- iOS
- Web
- Linux
- macOS
- Windows

## Project Structure

```
lib/
└── main.dart        # Entry point and all screens
    ├── MyApp        # Root app widget
    ├── MyHomePage   # Bottom navigation host
    ├── Screen1      # World Clock
    ├── Screen2      # Alarm
    ├── Screen3      # Timer
    └── Screen4      # Stopwatch
```

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | UI framework |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_lints` | ^5.0.0 | Lint rules |
