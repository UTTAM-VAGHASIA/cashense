# Cashense Project Structure

## Root Directory Organization
```
cashense/
├── .cursor/                    # Cursor IDE configuration
├── .git/                      # Git version control
├── .kiro/                     # Kiro AI assistant configuration
├── docs/                      # Project documentation
├── lib/                       # Flutter source code
├── android/                   # Android platform files
├── ios/                       # iOS platform files
├── web/                       # Web platform files
├── windows/                   # Windows platform files
├── macos/                     # macOS platform files
├── linux/                     # Linux platform files
├── test/                      # Test files
├── integration_test/          # Integration tests
├── assets/                    # Static assets
├── .gitignore                 # Git ignore rules
├── pubspec.yaml              # Flutter dependencies
├── README.md                 # Project overview
└── CONTRIBUTING.md           # Contribution guidelines
```

## Flutter Source Code Structure (lib/)
```
lib/
├── main.dart                          # Application entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget
│   ├── router/                       # Navigation configuration
│   ├── theme/                        # Theme configuration
│   └── localization/                 # Localization setup
├── core/                             # Core utilities and shared code
│   ├── constants/                    # App constants and enums
│   ├── extensions/                   # Dart extensions
│   ├── utils/                        # Utility functions
│   ├── validators/                   # Input validation
│   ├── formatters/                   # Data formatters
│   └── exceptions/                   # Custom exceptions
├── shared/                           # Shared components and services
│   ├── widgets/                      # Reusable UI components
│   ├── services/                     # Core services
│   ├── models/                       # Shared data models
│   └── providers/                    # Shared Riverpod providers
├── features/                         # Feature modules
│   ├── authentication/               # Auth feature
│   ├── accounts/                     # Account management
│   ├── transactions/                 # Transaction management
│   ├── budgets/                      # Budget management
│   ├── analytics/                    # Analytics and reporting
│   ├── groups/                       # Group finance features
│   └── settings/                     # App settings
└── l10n/                            # Localization files
```

## Feature Module Structure
Each feature follows clean architecture principles:
```
features/feature_name/
├── data/
│   ├── models/                       # Data models with JSON serialization
│   ├── repositories/                 # Repository implementations
│   └── datasources/                  # Local and remote data sources
├── domain/
│   ├── entities/                     # Business entities
│   ├── repositories/                 # Repository interfaces
│   └── usecases/                     # Business logic use cases
├── presentation/
│   ├── pages/                        # UI pages/screens
│   ├── widgets/                      # Feature-specific widgets
│   └── providers/                    # Riverpod providers for state
└── feature_name.dart                 # Feature barrel export
```

## Documentation Structure (docs/)
```
docs/
├── API.md                           # API documentation
├── ARCHITECTURE.md                  # Architecture overview
├── DEPLOYMENT.md                    # Deployment guide
├── TESTING.md                       # Testing guidelines
└── TROUBLESHOOTING.md              # Common issues and solutions
```

## Asset Organization
```
assets/
├── images/                          # App images and illustrations
│   ├── icons/                       # Custom icons
│   ├── logos/                       # App logos and branding
│   └── illustrations/               # UI illustrations
├── fonts/                           # Custom fonts
├── config/                          # Configuration files
└── data/                           # Static data files
```

## Test Structure
```
test/
├── unit/                           # Unit tests
│   ├── core/                       # Core utilities tests
│   ├── shared/                     # Shared services tests
│   └── features/                   # Feature-specific tests
├── widget/                         # Widget tests
└── helpers/                        # Test helpers and mocks

integration_test/
├── app_test.dart                   # Full app integration tests
├── auth_flow_test.dart            # Authentication flow tests
└── transaction_flow_test.dart      # Transaction flow tests
```

## Configuration Files
- **pubspec.yaml**: Flutter dependencies and asset declarations
- **analysis_options.yaml**: Dart/Flutter linting rules
- **firebase.json**: Firebase configuration
- **.env files**: Environment-specific configuration
- **build.gradle**: Android build configuration
- **Info.plist**: iOS configuration

## Naming Conventions
- **Files**: snake_case (e.g., `transaction_service.dart`)
- **Classes**: PascalCase (e.g., `TransactionService`)
- **Variables/Functions**: camelCase (e.g., `getUserTransactions`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `MAX_TRANSACTION_AMOUNT`)
- **Private members**: Prefix with underscore (e.g., `_privateMethod`)

## Import Organization
1. Dart imports (dart:*)
2. Flutter imports (package:flutter/*)
3. Package imports (alphabetical)
4. Local imports (alphabetical, relative paths)

## Key Architectural Patterns
- **Clean Architecture**: Separation of concerns across data, domain, and presentation layers
- **Repository Pattern**: Abstract data access with multiple data sources
- **Provider Pattern**: Riverpod for dependency injection and state management
- **Result Pattern**: Explicit error handling with Success/Failure types
- **Feature-First**: Organize code by features rather than technical layers