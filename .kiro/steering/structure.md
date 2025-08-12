# Project Structure

## Root Organization
```
cashense/                  # Main Flutter application
├── android/              # Android-specific configuration
├── ios/                  # iOS-specific configuration  
├── lib/                  # Dart source code
├── assets/               # App assets (images, fonts, icons)
├── pubspec.yaml          # Project dependencies
└── README.md             # Project overview
```

## Source Code Architecture (`lib/`)
```
lib/
├── app.dart              # App entry point
├── main.dart             # Main (fallback) function
├── bindings/             # GetX bindings for dependency injection
├── common/               # Common widgets and utilities
├── data/                 # Data models and repositories
├── features/             # Feature-based modules
├── flavors/              # Flavor configuration (dev/staging/prod)
├── localization/         # Localization files
└── utils/                # Utility functions and constants
```

## Architecture Patterns
- **Feature-based**: Code organized by features rather than layers
- **GetX Pattern**: State management, dependency injection, and routing
- **Repository Pattern**: Data layer abstraction in `data/` folder
- **Flavor Configuration**: Environment-specific builds (dev/staging/prod)

## Key Conventions
- **Entry Points**: Separate main files for each flavor (`main_development.dart`, `main_staging.dart`, etc.)
- **Bindings**: The bindings that are to be initialized throughout the app in `lib/bindings/` folder
- **Firebase Config**: Environment-specific Firebase options in `flavors/firebase/`
- **Assets Organization**: Separate folders for fonts, logos, icons, and images
- **Dependency Injection**: Centralized in `bindings/` folder using GetX
- **Common Components**: Reusable widgets and utilities in `common/`

## File Naming
- **Files**: snake_case (e.g., `user_profile.dart`)
- **Classes**: PascalCase (e.g., `UserProfile`)
- **Variables**: camelCase (e.g., `userName`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`)

## Feature Module Structure
Each feature should follow this pattern:
```
features/feature_name/
├── controllers/          # GetX controllers
├── models/              # Data models
├── views/               # UI screens
├── widgets/             # Feature-specific widgets
└── bindings/            # Feature bindings
```