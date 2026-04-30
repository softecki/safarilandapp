# Softecki FaceAccess Mobile App (`attendanceapp`)

Flutter mobile application for the Softecki FaceAccess ecosystem.

The app supports workforce operations such as gate attendance capture, employee login workflows, profile utilities, and API-connected sync with the `attendanceportal` backend.

## Core Features

- Gate access login and scanning workflow
- Employee attendance login workflow
- Quick switching between gate and employee login screens
- Offline-aware local storage and pending sync behavior
- API integration with attendance portal backend
- Branded app experience as **Softecki FaceAccess**

## Recent Product Behavior

- App branding updated to **Softecki FaceAccess** across screens and web manifest metadata.
- Login forms support switching:
  - Gate Access -> Employee Login
  - Employee Login -> Gate Access
- Login icon kept as fingerprint per current product decision.
- SMS Payment Processing default is set to `false` (disabled by default).

## Project Structure (high level)

- `lib/main.dart`: app bootstrap, theme, splash/start routing
- `lib/core/`: constants and shared app configuration
- `lib/src/view/screen/`: UI screens (login, profile, support, receipts, etc.)
- `lib/src/services/`: sync, API, SMS listener, and local service integrations
- `android/`, `ios/`, `web/`: platform-specific runtime configurations

## Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code
- Android SDK / emulator or physical test device

Check environment:

```bash
flutter doctor
```

## Local Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Run on connected device/emulator:

```bash
flutter run
```

3. Optional release build:

```bash
flutter build apk --release
```

## Backend Integration

This app is designed to work with the Laravel backend in `attendanceportal`.

Ensure backend API and auth/scanner endpoints are reachable from the mobile device network. Update base URL/API settings in app configuration before deployment.

## Web Build Metadata

Branding and metadata have been aligned to Softecki FaceAccess in:

- `web/index.html`
- `web/manifest.json`
- `web/sw.js`

## Troubleshooting

- If app fails to launch after dependency changes:

```bash
flutter clean
flutter pub get
flutter run
```

- If Android build tooling behaves inconsistently, re-run:

```bash
flutter doctor -v
```

## Notes

- Keep generated build artifacts out of commits unless explicitly required for release packaging.
- Coordinate API contract changes with `attendanceportal` to avoid sync or status-mapping regressions.
