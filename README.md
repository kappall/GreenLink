# GreenLink Mobile App

GreenLink is a cross-platform mobile application built with [Flutter](https://flutter.dev) that connects communities around environmental sustainability. It enables users to share environmental alerts, organize volunteering events, and explore an interactive map of local environmental activities.

## Features

### 🔔 Community Feed
- Browse and create posts about environmental notices and emergency alerts
- Filter and sort posts by date, proximity, and category
- Like and comment on posts
- Full-text search with pagination

### 🌿 Volunteering Events
- Discover local volunteering opportunities
- Create and manage events (for partners)
- QR code scanning for event check-in
- Filter by date, proximity, or participation status

### 🗺️ Interactive Map
- OpenStreetMap-based visualization of posts and events
- Category-based icons and color-coded markers
- Real-time user location tracking
- Tap markers for quick details with navigation to full views

### 👤 User Profiles
- View user activity: posts, events, and comments
- Edit profile information
- Role-based badges (user, partner, admin)

### 🔐 Authentication
- Email/password registration and login
- Anonymous browsing mode
- Partner activation via token
- Location-based onboarding

### ⚙️ Admin Dashboard
- User management and reporting
- Partner creation
- Content moderation

### 📍 Location Services
- Real-time geolocation
- Geocoding and reverse geocoding
- Configurable location preferences

### 📄 Legal
- In-app privacy policy and terms of service

## Tech Stack

| Technology | Purpose |
|---|---|
| [Flutter](https://flutter.dev) | Cross-platform UI framework |
| [Riverpod](https://riverpod.dev) | State management & dependency injection |
| [Go Router](https://pub.dev/packages/go_router) | Declarative routing & navigation |
| [Freezed](https://pub.dev/packages/freezed) | Immutable data models & unions |
| [flutter_map](https://pub.dev/packages/flutter_map) | OpenStreetMap-based interactive map |
| [Geolocator](https://pub.dev/packages/geolocator) | GPS location services |
| [Socket.IO](https://pub.dev/packages/socket_io_client) | Real-time WebSocket communication |
| [Mobile Scanner](https://pub.dev/packages/mobile_scanner) | QR code scanning |
| [image_picker](https://pub.dev/packages/image_picker) | Photo capture & selection |

## Getting Started

### Prerequisites

- **Flutter SDK** (≥ 3.9.2) — follow the [official installation guide](https://docs.flutter.dev/get-started/install)
- **Android Studio** — for the Android SDK, emulator, and build tools
- **Xcode** (macOS only) — for iOS development
- **Git**

Verify your setup by running:

```bash
flutter doctor
```

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd GreenLink
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run code generation** (for Freezed models and Riverpod providers)

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**

   Connect an Android/iOS device or start an emulator, then:

   ```bash
   flutter run
   ```

### Building for Release

#### Android APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

To install on a connected device:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### iOS

```bash
flutter build ios --release
```

Then archive and distribute through Xcode.

### Regenerating Assets

After modifying the app icon or splash screen assets:

```bash
# Regenerate splash screen
dart run flutter_native_splash:create

# Regenerate launcher icons
dart run flutter_launcher_icons
```

## Project Structure

```
lib/
├── main.dart              # App entry point & initialization
├── router.dart            # Navigation & routing configuration
├── core/                  # Shared infrastructure
│   ├── constants/         # Global constants & configuration
│   ├── services/          # Global services (e.g., WebSocket client)
│   ├── providers/         # Shared providers (e.g., geocoding)
│   ├── utils/             # Utility functions & helpers
│   └── common/widgets/    # Reusable UI components
├── features/              # Feature modules
│   ├── auth/              # Authentication & onboarding
│   ├── feed/              # Community post feed
│   ├── event/             # Volunteering events
│   ├── map/               # Interactive map
│   ├── user/              # User profiles
│   ├── admin/             # Admin dashboard
│   ├── settings/          # User preferences
│   ├── location/          # Location services
│   ├── legal/             # Legal documents
│   └── main-wrapper/      # Bottom navigation shell
└── theme/
    └── app_theme.dart     # Material 3 theme definition
```

Each feature module follows a consistent internal structure:

- **`models/`** — Data classes (typically generated with Freezed)
- **`providers/`** — Riverpod providers for state management
- **`pages/`** — Screen-level UI widgets
- **`widgets/`** — Feature-specific reusable widgets
- **`services/`** — Business logic and API interactions

## Architecture

GreenLink uses a **feature-based architecture** with a clear separation of concerns:

- **State Management**: [Riverpod](https://riverpod.dev) with code generation provides reactive state management and dependency injection across the app.
- **Navigation**: [Go Router](https://pub.dev/packages/go_router) handles declarative routing with authentication-aware redirects — unauthenticated users are redirected to login, while admin users get access to additional management routes.
- **Real-time Updates**: [Socket.IO](https://pub.dev/packages/socket_io_client) enables live updates to the feed and event data.
- **Data Models**: [Freezed](https://pub.dev/packages/freezed) generates immutable, serializable data classes with JSON support.
- **Theming**: Material 3 design with a green color scheme (`#059669`), ensuring a consistent and modern look.

## Additional Documentation

- [**README_CODE.md**](README_CODE.md) — Detailed code structure overview (in Italian)
- [**README_INSTALL.md**](README_INSTALL.md) — Android installation guide (in Italian)

## Troubleshooting

- Run `flutter doctor` to diagnose common setup issues.
- Ensure your device is recognized by `adb devices` (Android) or appears in Xcode (iOS).
- If you encounter dependency issues, try `flutter clean && flutter pub get`.
- For code generation issues, run `dart run build_runner build --delete-conflicting-outputs`.
