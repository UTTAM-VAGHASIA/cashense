# Cashense Architecture Guide

This document provides a comprehensive overview of Cashense's architecture, design decisions, and implementation patterns for our AI-powered, cross-platform financial management application.

## 🏗️ System Architecture Overview

Cashense follows a modern, scalable architecture built on Firebase backend-as-a-service with Flutter as the cross-platform frontend framework. The system is designed to serve as the ultimate financial companion for individuals and groups, combining traditional expense tracking with intelligent features and social finance capabilities.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Mobile    │  │     Web     │  │      Desktop        │  │
│  │    (iOS/    │  │   (PWA)     │  │   (Windows/Mac/     │  │
│  │   Android)  │  │             │  │      Linux)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────────────┐
                    │    Riverpod     │
                    │ State Management│
                    └─────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Local Storage Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    Hive     │  │   Secure    │  │    SharedPrefs      │  │
│  │  Database   │  │   Storage   │  │    (Settings)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Backend                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Firestore  │  │    Auth     │  │      Storage        │  │
│  │  Database   │  │   Service   │  │     (Files)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Functions  │  │ AI Logic/   │  │    Analytics/       │  │
│  │ (Serverless)│  │   Gemini    │  │   Crashlytics       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🏛️ MVVM Architecture Pattern

### Architecture Migration

Cashense has successfully migrated from Clean Architecture (data/domain/presentation layers) to Flutter's recommended MVVM pattern. This migration provides:

- **Simplified Structure**: Reduced complexity by consolidating three layers into a more manageable MVVM pattern
- **Better Developer Experience**: More intuitive Flutter development patterns with clearer separation of concerns
- **Improved Maintainability**: Easier navigation and file discovery with feature-based organization
- **Enhanced Testability**: Clearer test organization with focused unit test scope

### MVVM Components

#### Models Layer
- **Purpose**: Data models with business logic, validation, and serialization
- **Location**: `lib/models/`
- **Features**: 
  - JSON serialization (fromJson/toJson)
  - Data validation methods
  - Business logic integration
  - Immutability with copyWith methods
  - Proper equality implementation

#### Views Layer
- **Purpose**: UI components, pages, and widgets
- **Location**: `lib/views/`
- **Features**:
  - Feature-based organization
  - Shared component reusability
  - Reactive UI updates with Riverpod
  - Platform-adaptive design

#### ViewModels Layer
- **Purpose**: State management and business logic coordination
- **Location**: `lib/viewmodels/`
- **Features**:
  - Riverpod StateNotifier integration
  - Direct service calls (no repository abstraction)
  - Reactive state management
  - Error handling with AsyncValue pattern

### Migration Benefits

1. **Reduced Boilerplate**: Eliminated repository abstraction layer
2. **Clearer Architecture**: More intuitive for Flutter developers
3. **Better Performance**: Direct service calls reduce overhead
4. **Simplified Testing**: Focused mocking requirements
5. **Enhanced Productivity**: Faster development cycles

## 🎯 Design Principles

### 1. Cost-Effective Architecture
- **Target**: $0-10/month operational costs (freemium model)
- **Strategy**: Leverage Firebase free tiers effectively
- **Monitoring**: Automated cost tracking and alerts
- **Premium Features**: Advanced analytics and integrations for revenue generation

### 2. Cross-Platform Consistency
- **Single Codebase**: Flutter for all platforms
- **Responsive Design**: Adaptive UI for different screen sizes
- **Platform Integration**: Native features where needed

### 3. Offline-First Design
- **Local Storage**: Hive for primary data storage
- **Sync Strategy**: Delta synchronization with conflict resolution
- **User Experience**: Full functionality without internet

### 4. Scalable State Management
- **Riverpod**: Compile-time safe providers
- **Reactive Programming**: Stream-based data flow
- **Performance**: Efficient rebuilds and caching

### 5. Security by Design
- **End-to-End Encryption**: All financial data encrypted
- **Zero-Trust**: Verify all requests and data
- **Privacy First**: Local data storage options

### 6. Target User Architecture
The system is designed to serve multiple user segments:
- **Individuals**: Personal finance management with AI assistance
- **Families**: Shared expense management with role-based permissions
- **Small Businesses**: Expense tracking and cash flow management
- **Groups**: Collaborative expense sharing and settlement optimization

## 🔧 MVVM Implementation Details

### Model Implementation

Models in Cashense combine data representation with business logic:

```dart
// Example: lib/models/features/settings/app_settings_model.dart
@freezed
class AppSettingsModel with _$AppSettingsModel {
  const factory AppSettingsModel({
    required String theme,
    required String language,
    required String currency,
    required bool notificationsEnabled,
    required bool biometricEnabled,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  // Business logic methods
  const AppSettingsModel._();
  
  bool get isDarkTheme => theme == 'dark';
  bool get isSystemTheme => theme == 'system';
  
  AppSettingsModel toggleTheme() {
    return copyWith(
      theme: isDarkTheme ? 'light' : 'dark',
    );
  }
}
```

### ViewModel Implementation

ViewModels manage state and coordinate business logic:

```dart
// Example: lib/viewmodels/features/settings/settings_viewmodel.dart
class SettingsViewModel extends StateNotifier<AsyncValue<AppSettingsModel>> {
  SettingsViewModel(this._prefs, this._crashlytics) 
      : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  final SharedPreferences _prefs;
  final CrashlyticsService _crashlytics;

  Future<void> _loadSettings() async {
    try {
      final settings = await _loadFromPreferences();
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      await _crashlytics.recordError(error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTheme(String theme) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    try {
      final updatedSettings = currentSettings.copyWith(theme: theme);
      await _saveToPreferences(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (error, stackTrace) {
      await _crashlytics.recordError(error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Direct service calls - no repository layer
  Future<AppSettingsModel> _loadFromPreferences() async {
    return AppSettingsModel(
      theme: _prefs.getString('theme') ?? 'system',
      language: _prefs.getString('language') ?? 'en',
      currency: _prefs.getString('currency') ?? 'USD',
      notificationsEnabled: _prefs.getBool('notifications') ?? true,
      biometricEnabled: _prefs.getBool('biometric') ?? false,
    );
  }
}
```

### View Implementation

Views consume ViewModels and render UI:

```dart
// Example: lib/views/features/settings/pages/settings_page.dart
class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: settingsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(error),
        data: (settings) => _buildSettingsContent(context, ref, settings),
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    WidgetRef ref,
    AppSettingsModel settings,
  ) {
    return ListView(
      children: [
        ListTile(
          title: Text('Theme'),
          subtitle: Text(settings.theme),
          trailing: DropdownButton<String>(
            value: settings.theme,
            onChanged: (theme) {
              if (theme != null) {
                ref.read(settingsViewModelProvider.notifier).updateTheme(theme);
              }
            },
            items: ['light', 'dark', 'system']
                .map((theme) => DropdownMenuItem(
                      value: theme,
                      child: Text(theme),
                    ))
                .toList(),
          ),
        ),
        // Additional settings...
      ],
    );
  }
}
```

### Provider Configuration

Centralized provider exports for dependency injection:

```dart
// lib/viewmodels/providers.dart - Barrel file for all providers
export 'features/settings/settings_viewmodel.dart'
    show settingsViewModelProvider, SettingsViewModel, sharedPreferencesProvider;

export '../app/theme/app_theme.dart' 
    show themeModeProvider, ThemeModeNotifier;

export '../app/router/app_router.dart' 
    show appRouterProvider, RouteNames;

// Utility exports
export '../utils/result.dart';
export '../utils/exceptions.dart';
```

#### Theme Provider Implementation
```dart
// Theme management with persistence
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(sharedPreferencesProvider)),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final SharedPreferences _prefs;
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state != mode) {
      state = mode;
      await _prefs.setInt('theme_mode', mode.index);
    }
  }
  
  Future<void> toggleTheme() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(newMode);
  }
}
```

## 📱 Frontend Architecture

### Flutter Application Structure

Cashense has migrated to Flutter's recommended MVVM (Model-View-ViewModel) architecture pattern for improved maintainability and developer experience:

```
lib/
├── main.dart                          # Application entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget
│   ├── router/                       # Navigation configuration
│   ├── theme/                        # Theme configuration
│   └── localization/                 # Localization setup
├── models/                           # Data models and business entities
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
│   └── providers.dart                # Riverpod provider exports
├── services/                         # Core services and integrations
│   ├── firebase_service.dart         # Firebase integration
│   ├── crashlytics_service.dart      # Error reporting
│   ├── storage_service.dart          # Local storage
│   ├── auth_service.dart             # Authentication service
│   └── ai_service.dart               # AI/ML integration
├── utils/                            # Utility functions and helpers
│   ├── exceptions.dart               # Custom exceptions
│   ├── validators.dart               # Input validation
│   ├── formatters.dart               # Data formatters
│   └── extensions.dart               # Dart extensions
├── constants/                        # App constants and configuration
│   └── app_constants.dart            # Application constants
└── l10n/                            # Localization files
```

## 🗄️ Data Architecture

### Technology Stack

**Frontend Framework:**
- Flutter SDK (latest stable via FVM) for cross-platform development
- Material 3 design system for consistent UI/UX
- Single codebase targeting mobile, web, and desktop

**State Management:**
- Riverpod (latest version) for compile-time safety and advanced async/sync providers
- Provider as fallback for simpler use cases

**Backend & Database (Firebase-Only):**
- Firebase Firestore for primary data storage (1GB + 50K reads/20K writes free)
- Firebase Authentication for user management (50K MAU free tier)
- Firebase Storage for file attachments (5GB free)
- Firebase Functions for serverless backend logic (2M invocations/month free)
- Firebase Hosting for web deployment (10GB storage + 360MB/day transfer free)
- Firebase Analytics for user behavior tracking and insights
- Firebase Crashlytics for error reporting and crash analysis
- Firebase Messaging for push notifications and real-time alerts

**Local Storage:**
- Hive (^2.2.3) for mobile/desktop/web local storage (faster than Isar, simpler API)
- flutter_secure_storage (^4.2.1) for sensitive data encryption
- SharedPreferences (^2.5.3) for app settings and preferences

## 🛡️ Error Handling Architecture

### Global Error Management

Cashense implements a comprehensive error handling system designed for financial applications where reliability is critical:

#### Error Boundary Implementation
```dart
// Global error zone in main.dart
await runZonedGuarded<Future<void>>(
  () async {
    await _initializeApp();
  },
  (error, stack) => _handleGlobalError(error, stack),
);
```

#### Error Recovery Patterns
- **Graceful Degradation**: App continues functioning with reduced features during errors
- **User-Friendly Messages**: Technical errors translated to user-understandable messages
- **Automatic Retry**: Network and initialization errors include retry mechanisms
- **Error Reporting**: All errors automatically logged to Crashlytics for analysis

#### Error Screen Implementation
- Custom error widgets for different error types
- Debug information available in development mode
- Restart functionality for critical errors
- Contextual error messages based on error type

### App Initialization Architecture

#### Robust Initialization Process
```dart
Future<void> _initializeApp() async {
  // 1. Initialize core services with timeout
  await _initializeCoreServices();
  
  // 2. Initialize local storage
  await _initializeLocalStorage();
  
  // 3. Initialize SharedPreferences with retry
  final sharedPreferences = await _initializeSharedPreferences();
  
  // 4. Setup error handlers
  _setupErrorHandlers();
  
  // 5. Launch app
  _launchApp(sharedPreferences);
}
```

#### Service Initialization Features
- **Timeout Protection**: 30-second timeout for Firebase initialization
- **Retry Logic**: Automatic retry for SharedPreferences initialization
- **Error Recovery**: Fallback error app if initialization fails
- **Dependency Injection**: Proper provider setup with initialized services

## 🎨 Theming Architecture

### Material 3 Implementation

Cashense uses an advanced theming system built on Material 3 with financial app-specific enhancements:

#### Dynamic Color Integration
```dart
return DynamicColorBuilder(
  builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    return MaterialApp.router(
      theme: AppTheme.light(lightDynamic),
      darkTheme: AppTheme.dark(darkDynamic),
      themeMode: themeMode,
    );
  },
);
```

#### Financial Color System
```dart
@immutable
class FinancialColors extends ThemeExtension<FinancialColors> {
  const FinancialColors({
    required this.income,      // Green for income
    required this.expense,     // Red for expenses
    required this.investment,  // Purple for investments
    required this.savings,     // Blue for savings
    required this.success,     // Success states
    required this.warning,     // Warning states
    required this.info,        // Information states
  });
}
```

#### Theme Persistence
- **StateNotifier Integration**: Reactive theme management with Riverpod
- **SharedPreferences Storage**: Theme preference persistence across app restarts
- **System Theme Detection**: Automatic light/dark mode based on system settings
- **Toggle Functionality**: Easy theme switching with state management

#### Advanced Theme Features
- **Tabular Figures**: Monospace numbers for financial data display
- **Enhanced Typography**: Optimized text styles for financial information
- **Semantic Colors**: Context-aware colors for different transaction types
- **Accessibility**: High contrast ratios and proper color semantics
- **Cross-Platform**: Consistent theming across mobile, web, and desktop

### Theme Usage Patterns
```dart
// Access theme colors
final theme = Theme.of(context);
final financialColors = theme.financialColors;

// Use in widgets
Container(
  color: financialColors.income,
  child: Text(
    '\$1,234.56',
    style: theme.textTheme.headlineMedium?.copyWith(
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  ),
)

// Theme switching
ref.read(themeModeProvider.notifier).toggleTheme();
```

## 🔐 Security Architecture

### Data Protection
- End-to-end encryption for all financial data
- Local data encryption using Hive encryption
- Secure key storage with flutter_secure_storage
- TLS encryption for all network communications

### Authentication
- Multi-factor authentication support
- Biometric authentication (fingerprint, face)
- Session management with automatic timeout
- OAuth integration for social logins

## 🤖 AI/ML Architecture

### AI Integration
- Firebase AI Logic (Vertex AI integration) for intelligent categorization
- Gemini in Firebase for contextual awareness and insights
- OpenAI API for advanced NLP processing (pay-per-use, cost-optimized)
- Local alternatives: flutter_tts (^4.2.3) + speech_to_text for offline voice features
- Natural language transaction parsing and voice input capabilities

## 📊 Performance Architecture

### Optimization Strategies
- Lazy loading for large datasets
- Image optimization and caching
- Efficient Firestore queries with composite indexes
- Local storage optimization with automatic cleanup
- Progressive sync with priority-based updates

### Monitoring
- Firebase Performance Monitoring
- Crashlytics for error tracking
- Analytics for user behavior insights
- Custom performance metrics

## 🚀 Deployment Architecture

### Platform Support
- **Mobile**: iOS (12.0+) and Android (API 21+)
- **Web**: PWA with offline capabilities
- **Desktop**: Windows 10+, macOS 10.14+, Ubuntu 18.04+

### CI/CD Pipeline
- GitHub Actions for automated testing and deployment
- Firebase Hosting for web deployment
- Firebase App Distribution for mobile app testing
- Automated code quality checks and test coverage

## 🛠️ Development Tools & Environment

### Integrated Development Tools

**Model Context Protocol (MCP) Integration:**
- **GitMCP Server**: Currently configured for repository integration via `mcp-remote` package
  - Enables AI-assisted Git operations and repository analysis
  - Configured at user level (`~/.kiro/settings/mcp.json`) for cross-project availability
  - Provides contextual repository information to Kiro AI assistant
  - Command: `npx mcp-remote https://gitmcp.io/{owner}/{repo}`
- **Sequential Thinking MCP Server**: Advanced reasoning capabilities for complex problem-solving
  - Provides structured thinking processes for development decisions
  - Command: `npx -y @modelcontextprotocol/server-sequential-thinking`
  - Enables multi-step analysis and solution development
- **Flutter Inspector MCP Server**: Available for integration using `flutter-mcp` package
  - Can provide real-time widget tree inspection and performance analysis through AI-assisted workflows
  - Connects to Dart VM (localhost:8181) for live application debugging during development
  - Supports comprehensive resource inspection, image analysis, and widget property examination
  - Can be configured via `.kiro/settings/mcp.json` with `npx flutter-mcp --stdio` command execution

**Development Environment Setup:**
```bash
# Install FVM (Flutter Version Management)
dart pub global activate fvm

# Install Firebase CLI
npm install -g firebase-tools

# Install MCP Remote (for GitMCP integration)
npm install -g mcp-remote

# Verify installations
fvm --version
firebase --version
flutter doctor
npx mcp-remote --version

# Test MCP servers
npx -y @modelcontextprotocol/server-sequential-thinking
npx mcp-remote https://gitmcp.io/{owner}/{repo}
```

## 🔄 Development Workflow

### Multi-Developer Architecture

The system is designed to support three parallel development streams based on the comprehensive 32-task implementation plan:

**Stream 1: Core Infrastructure & Authentication (Tasks 7-11)**
- **Task 7**: Core data models with Freezed and code generation
- **Task 8**: Local storage foundation with Hive encryption and sync queue
- **Task 9**: Firebase authentication with biometric and 2FA support
- **Task 10**: Riverpod state management with error handling providers
- **Task 11**: End-to-end security with data encryption and session management

**Stream 2: Financial Data Management (Tasks 12-17)**
- **Task 12**: Multi-cashbook management with role-based permissions
- **Task 13**: Hierarchical account structure supporting 3 levels with denomination tracking
- **Task 14**: Core transaction management with categorization and splitting
- **Task 15**: Budget management with configurable alerts and rollover functionality
- **Task 16**: Savings goals with automatic contribution calculations
- **Task 17**: Comprehensive analytics with custom report builder and data export

**Stream 3: Advanced Features & Integration (Tasks 18-23)**
- **Task 18**: AI-powered NLP for transaction parsing and voice input
- **Task 19**: Advanced transaction features (GPS, receipts, bulk operations)
- **Task 20**: Social finance with group expense sharing and settlement optimization
- **Task 21**: Loan and debt management with flexible settlement options
- **Task 22**: Investment tracking with real-time market data and performance calculation
- **Task 23**: Bank integration with OAuth and intelligent transaction import

### Integration Points

**Phase 3 Integration Tasks (Tasks 24-32)**
- **Task 24**: Subscription and recurring transaction management
- **Task 25**: Advanced notification system with predictive alerts
- **Task 26**: Data import/export supporting multiple formats (CSV, QIF, OFX, Excel)
- **Task 27**: Real-time cross-platform synchronization with conflict resolution
- **Task 28**: Responsive UI with Material 3 components and accessibility support
- **Task 29**: Performance optimization with efficient rendering and caching
- **Task 30**: Comprehensive testing (unit, widget, integration, performance)
- **Task 31**: Deployment and DevOps with CI/CD pipeline
- **Task 32**: Final integration with error handling and user onboarding

**Development Coordination:**
- Standardized data models with Freezed annotations
- Consistent error handling with Result<T> pattern
- Unified state management through Riverpod providers
- Common service interfaces for cross-stream dependencies
- Shared utilities and constants for consistent behavior

## 📚 Documentation Standards

This architecture supports comprehensive documentation including:
- API documentation with Dart Doc
- Architecture Decision Records (ADRs)
- Code examples and usage patterns
- Deployment and troubleshooting guides

---

This architecture is designed to be scalable, maintainable, and cost-effective while providing enterprise-grade functionality through Firebase's comprehensive suite of services.