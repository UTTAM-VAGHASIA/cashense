# Design Document

## Overview

This design outlines the migration from the current Clean Architecture pattern (data/domain/presentation layers) to Flutter's recommended MVVM (Model-View-ViewModel) pattern. The migration will simplify the codebase structure while maintaining all existing functionality and improving developer experience.

The current structure follows Clean Architecture with three distinct layers:
- **Data Layer**: Repository implementations, data sources
- **Domain Layer**: Entities, repository interfaces, use cases
- **Presentation Layer**: UI components, providers/state management

The new MVVM structure will consolidate these into:
- **Models**: Data models with business logic
- **Views**: UI components (pages, widgets)
- **ViewModels**: State management and business logic coordination
- **Services**: Core services and utilities

## Architecture

### Current Structure Analysis
```
lib/
├── features/
│   └── feature_name/
│       ├── data/
│       │   └── repositories/          # Repository implementations
│       ├── domain/
│       │   ├── entities/              # Business entities
│       │   └── repositories/          # Repository interfaces
│       └── presentation/
│           ├── pages/                 # UI pages
│           └── providers/             # Riverpod providers
├── shared/
│   ├── services/                      # Core services
│   └── widgets/                       # Shared UI components
└── core/
    ├── constants/                     # App constants
    ├── utils/                         # Utility functions
    └── exceptions/                    # Custom exceptions
```

### Target MVVM Structure
```
lib/
├── models/
│   ├── shared/                        # Shared data models
│   └── features/
│       └── feature_name/              # Feature-specific models
├── views/
│   ├── shared/                        # Shared UI components
│   └── features/
│       └── feature_name/              # Feature-specific views
├── viewmodels/
│   ├── shared/                        # Shared view models
│   └── features/
│       └── feature_name/              # Feature-specific view models
├── services/                          # Core services (unchanged)
├── utils/                             # Utility functions (unchanged)
├── constants/                         # App constants (unchanged)
└── app/                              # App configuration (unchanged)
```

## Components and Interfaces

### 1. Models Directory Structure
**Purpose**: Consolidate entities and data models into a single location
- Merge domain entities and data models
- Include JSON serialization, validation, and business logic
- Maintain immutability and copyWith methods
- Remove repository interfaces (direct service calls in ViewModels)

**Migration Strategy**:
- Move `domain/entities/*.dart` → `models/features/feature_name/`
- Enhance models with any additional data layer logic
- Remove repository abstractions

### 2. Views Directory Structure
**Purpose**: Organize all UI components in a clear hierarchy
- Move all presentation layer UI components
- Maintain feature-based organization
- Keep shared widgets accessible

**Migration Strategy**:
- Move `presentation/pages/*.dart` → `views/features/feature_name/pages/`
- Move `presentation/widgets/*.dart` → `views/features/feature_name/widgets/`
- Move `shared/widgets/*.dart` → `views/shared/`

### 3. ViewModels Directory Structure
**Purpose**: Consolidate state management and business logic
- Combine Riverpod providers with repository logic
- Direct service calls instead of repository pattern
- Maintain reactive state management with Riverpod
- Include business logic coordination

**Migration Strategy**:
- Move `presentation/providers/*.dart` → `viewmodels/features/feature_name/`
- Integrate repository implementation logic directly into ViewModels
- Remove repository layer abstractions
- Maintain Riverpod StateNotifier pattern

### 4. Services Directory (Minimal Changes)
**Purpose**: Keep core services unchanged
- Firebase services
- Crashlytics service
- Storage services
- Network services

**Migration Strategy**:
- Move `shared/services/*.dart` → `services/`
- No structural changes to service implementations

### 5. Utils and Constants (Minimal Changes)
**Purpose**: Flatten utility organization
- Move `core/utils/*.dart` → `utils/`
- Move `core/constants/*.dart` → `constants/`
- Move `core/exceptions/*.dart` → `utils/exceptions.dart`

## Data Models

### Model Enhancement Strategy
Each model will be enhanced to include:

1. **Data Validation**: Built-in validation methods
2. **JSON Serialization**: fromJson/toJson methods
3. **Business Logic**: Domain-specific methods
4. **Immutability**: copyWith methods and final fields
5. **Equality**: Proper equals and hashCode implementation

**Example Model Structure**:
```dart
// models/features/settings/app_settings_model.dart
class AppSettingsModel {
  // Properties, constructors, methods
  // Includes validation, serialization, business logic
}
```

### ViewModel Integration
ViewModels will directly use models and services:

```dart
// viewmodels/features/settings/settings_viewmodel.dart
class SettingsViewModel extends StateNotifier<AsyncValue<AppSettingsModel>> {
  final SharedPreferences _prefs;
  final CrashlyticsService _crashlytics;
  
  // Direct service calls, no repository layer
}
```

## Error Handling

### Centralized Error Management
- Move `core/exceptions/*.dart` → `utils/exceptions.dart`
- ViewModels handle errors directly
- Maintain AsyncValue pattern for error states
- Service-level error handling remains unchanged

### Error Propagation Strategy
1. **Service Level**: Services throw specific exceptions
2. **ViewModel Level**: ViewModels catch and convert to AsyncValue.error
3. **View Level**: Views handle AsyncValue error states

## Testing Strategy

### Test Structure Migration
```
test/
├── models/                            # Model unit tests
│   ├── shared/
│   └── features/
├── viewmodels/                        # ViewModel unit tests
│   ├── shared/
│   └── features/
├── views/                             # Widget tests
│   ├── shared/
│   └── features/
├── services/                          # Service unit tests
└── integration/                       # Integration tests
```

### Testing Approach
1. **Model Tests**: Focus on validation, serialization, business logic
2. **ViewModel Tests**: Mock services, test state management
3. **View Tests**: Widget testing with mocked ViewModels
4. **Service Tests**: Unchanged, test service implementations
5. **Integration Tests**: End-to-end feature testing

## Migration Implementation Plan

### Phase 1: Directory Structure Setup
1. Create new MVVM directory structure
2. Set up barrel exports for each directory
3. Prepare migration scripts/helpers

### Phase 2: Model Migration
1. Move and consolidate entities and data models
2. Enhance models with additional functionality
3. Update imports and exports

### Phase 3: Service Consolidation
1. Move shared services to services/ directory
2. Update service imports across codebase
3. Flatten core utilities

### Phase 4: ViewModel Migration
1. Migrate providers to ViewModels
2. Integrate repository logic directly into ViewModels
3. Remove repository layer abstractions
4. Update state management patterns

### Phase 5: View Migration
1. Move presentation components to views/
2. Update imports and widget references
3. Maintain UI functionality

### Phase 6: Cleanup and Testing
1. Remove old directory structure
2. Update all imports and exports
3. Run comprehensive tests
4. Update documentation

## Benefits of MVVM Migration

### Simplified Architecture
- Reduces three layers to a more manageable structure
- Eliminates repository abstraction overhead
- Clearer separation of concerns

### Improved Developer Experience
- Easier navigation and file discovery
- Reduced boilerplate code
- More intuitive Flutter development patterns

### Maintained Functionality
- All existing features preserved
- State management patterns unchanged
- Service layer remains robust

### Better Testability
- Clearer test organization
- Simplified mocking requirements
- Focused unit test scope

## Risk Mitigation

### Import Management
- Systematic import updates using IDE refactoring tools
- Barrel file exports to minimize import changes
- Gradual migration to prevent breaking changes

### State Management Continuity
- Maintain Riverpod patterns throughout migration
- Preserve existing provider functionality
- Ensure reactive state updates continue working

### Feature Preservation
- Comprehensive testing at each migration phase
- Feature-by-feature validation
- Rollback strategy for each migration step