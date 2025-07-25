# Cashense Project Structure

## MVVM Architecture Pattern

Cashense follows Flutter's recommended MVVM (Model-View-ViewModel) architecture pattern, recently migrated from Clean Architecture for improved maintainability and developer experience.

## Directory Structure

```
lib/
├── main.dart                          # Application entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget with error handling
│   ├── router/                       # Navigation configuration (go_router)
│   ├── theme/                        # Material 3 theme configuration
│   └── localization/                 # Localization setup
├── models/                           # Data models with business logic
│   ├── shared/                       # Shared data models
│   └── features/                     # Feature-specific models
│       ├── auth/                     # Authentication models
│       ├── settings/                 # Settings models
│       ├── accounts/                 # Account management models
│       ├── transactions/             # Transaction models
│       ├── budgets/                  # Budget models
│       └── analytics/                # Analytics models
├── views/                            # UI components and pages
│   ├── shared/                       # Reusable UI components
│   └── features/                     # Feature-specific views
│       ├── auth/                     # Authentication pages
│       ├── settings/                 # Settings pages
│       ├── accounts/                 # Account management views
│       ├── transactions/             # Transaction views
│       ├── budgets/                  # Budget views
│       └── analytics/                # Analytics views
├── viewmodels/                       # State management and business logic
│   ├── shared/                       # Shared view models
│   ├── features/                     # Feature-specific view models
│   │   ├── auth/                     # Authentication view models
│   │   ├── settings/                 # Settings view models
│   │   ├── accounts/                 # Account management view models
│   │   ├── transactions/             # Transaction view models
│   │   ├── budgets/                  # Budget view models
│   │   └── analytics/                # Analytics view models
│   └── providers.dart                # Centralized Riverpod provider exports
├── services/                         # Core services and integrations
│   ├── firebase_service.dart         # Firebase integration
│   ├── crashlytics_service.dart      # Error reporting
│   ├── storage_service.dart          # Local storage (Hive)
│   ├── auth_service.dart             # Authentication service
│   └── ai_service.dart               # AI/ML integration
├── utils/                            # Utility functions and helpers
│   ├── exceptions.dart               # Custom exceptions
│   ├── validators.dart               # Input validation
│   ├── formatters.dart               # Data formatters
│   ├── extensions.dart               # Dart extensions
│   └── result.dart                   # Result type for error handling
├── constants/                        # App constants and configuration
│   └── app_constants.dart            # Application constants
└── l10n/                            # Localization files
```

## MVVM Component Responsibilities

### Models (`lib/models/`)
- Data representation with business logic
- JSON serialization (fromJson/toJson)
- Data validation methods
- Immutability with copyWith methods
- Use `@freezed` annotation for data classes
- Business logic integration

### Views (`lib/views/`)
- UI components, pages, and widgets
- Feature-based organization
- Shared component reusability
- Reactive UI updates with Riverpod
- Platform-adaptive design
- Consumer widgets for state management

### ViewModels (`lib/viewmodels/`)
- State management with Riverpod StateNotifier
- Business logic coordination
- Direct service calls (no repository abstraction)
- Error handling with AsyncValue pattern
- Reactive state management

## Code Organization Conventions

### File Naming
- Use snake_case for file names
- Suffix with component type: `_model.dart`, `_viewmodel.dart`, `_page.dart`, `_widget.dart`
- Group related files in feature folders

### Import Organization
```dart
// Dart/Flutter imports first
import 'dart:async';
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Local imports last
import '../models/user_model.dart';
import '../services/auth_service.dart';
```

### Provider Exports
- All providers exported from `lib/viewmodels/providers.dart`
- Use barrel exports for clean imports
- Centralized dependency injection configuration

## Code Generation

### Required Annotations
- `@freezed` for immutable data classes
- `@JsonSerializable()` for JSON serialization
- `@HiveType()` for local storage models

### Generation Commands
```bash
# Generate code after model changes
fvm flutter packages pub run build_runner build

# Watch mode for continuous generation
fvm flutter packages pub run build_runner watch
```

## Testing Structure

```
test/
├── models/                           # Model unit tests
├── viewmodels/                       # ViewModel unit tests
├── views/                            # Widget tests
├── services/                         # Service unit tests
├── utils/                            # Utility function tests
└── integration/                      # Integration tests
```

## Asset Organization

```
assets/
├── images/                           # App images and illustrations
├── icons/                            # Custom icons and graphics
├── config/                           # Configuration files
└── data/                             # Static data files
```

## Configuration Files

### Key Configuration
- `pubspec.yaml`: Dependencies and asset configuration
- `analysis_options.yaml`: Strict linting rules for financial app
- `build.yaml`: Code generation configuration
- `l10n.yaml`: Localization configuration
- `firebase.json`: Firebase project configuration

### Development Tools
- `.fvmrc`: Flutter version management
- `.kiro/`: AI assistant configuration and steering rules
- `devtools_options.yaml`: Flutter DevTools configuration

## Migration Notes

### From Clean Architecture to MVVM
- **Eliminated**: Repository abstraction layer
- **Consolidated**: Data/domain/presentation into models/views/viewmodels
- **Maintained**: Feature-based organization
- **Enhanced**: Direct service calls for better performance
- **Preserved**: All existing functionality during migration

## Best Practices

### State Management
- Always use context7 to get latest documentation for minimum usage of deprecations
- Use AsyncValue for async operations
- Handle loading, error, and data states explicitly
- Implement proper error boundaries
- Use StateNotifier for complex state logic

### Error Handling
- Custom exceptions in `utils/exceptions.dart`
- Comprehensive error logging with Crashlytics
- User-friendly error messages
- Graceful degradation for offline scenarios

### Performance
- Lazy loading for large datasets
- Efficient Firestore queries
- Image caching and optimization
- Local storage cleanup strategies