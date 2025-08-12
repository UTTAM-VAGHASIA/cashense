# Technology Stack

## Core Technologies
- **Frontend**: Flutter (Dart) with FVM (Flutter Version Management)
- **Flutter Version**: 3.32.8 (managed via `.fvmrc`)
- **Backend**: Firebase suite (Firestore, Authentication, Storage, Cloud Functions)
- **State Management**: GetX
- **Navigation**: GoRouter
- **Local Storage**: Flutter Secure Storage, SharedPreferences, Drift (SQLite)

## Key Dependencies
- **Firebase**: Core, Auth, Firestore, Analytics
- **UI/UX**: Dynamic Color, Device Preview, Shimmer
- **Networking**: Dio, Connectivity Plus
- **Localization**: Easy Localization
- **Authentication**: Google Sign-In All Platforms
- **Utilities**: Intl, URL Launcher, Haptic Feedback

## Build System & Flavors
- **Flavors**: Development, Staging, Production
- **Firebase Projects**: 
  - Dev: `cashense-dev`
  - Staging: `cashense-staging` 
  - Production: `cashense-prod`
- **Launcher Icons**: Separate configurations for each flavor

## Development Tools
- **Linting**: Flutter Lints with custom analysis options
- **Code Generation**: Build Runner, Drift Dev
- **Icons**: Flutter Launcher Icons

## Common Commands
```bash
# Setup FVM and install Flutter version
fvm install
fvm use

# Get dependencies
fvm flutter pub get

# Run code generation
fvm dart run build_runner build

# Run different flavors
fvm flutter run --flavor development -t lib/main_development.dart
fvm flutter run --flavor staging -t lib/main_staging.dart
fvm flutter run --flavor production -t lib/main_production.dart

# Build for release
fvm flutter build apk --flavor production -t lib/main_production.dart
fvm flutter build ios --flavor production -t lib/main_production.dart

# Analyze code
fvm flutter analyze

# Run tests
fvm flutter test

# Generate launcher icons
fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-dev.yaml
fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-staging.yaml
fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-prod.yaml
```

## Code Style
- **Formatter**: Preserve trailing commas
- **Linting**: Standard Flutter lints enabled
- **File Naming**: Snake case for files, PascalCase for classes