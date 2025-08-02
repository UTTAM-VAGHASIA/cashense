# Cashense - AI-Powered Financial Management Platform

Cashense is an AI-powered, cross-platform financial management application that combines traditional expense tracking with intelligent features and social finance capabilities. Built with Flutter and Firebase, it serves as the ultimate financial companion for individuals and groups, providing comprehensive financial management tools that are intelligent, accessible, and cost-effective.

## 🌟 Key Features

- **Multi-Platform**: Single Flutter codebase for mobile (iOS/Android), web, and desktop
- **AI-Powered**: Natural language processing for effortless transaction entry and voice input
- **Multi-Cashbook**: Separate financial contexts (personal, business, family) with role-based permissions
- **Social Finance**: Group expense sharing, debt tracking, and settlement optimization
- **Advanced Analytics**: Comprehensive reporting, spending insights, and financial health scoring
- **Investment Tracking**: Portfolio management with real-time market data
- **Bank Integration**: Secure automatic transaction import with intelligent categorization
- **Offline-First**: Full functionality with local storage and seamless synchronization

## 🏗️ Architecture Overview

Cashense follows Flutter's recommended MVVM (Model-View-ViewModel) architecture pattern, built on Firebase backend-as-a-service for optimal development experience and maintainability:

```
Flutter Application (Cross-Platform)
├── Mobile (iOS/Android)
├── Web (PWA)
└── Desktop (Windows/Mac/Linux)

MVVM Architecture Pattern
├── Models (Data & Business Logic)
├── Views (UI Components & Pages)
└── ViewModels (State Management & Coordination)

State Management: Riverpod
├── ViewModels with StateNotifier
├── Provider-based Dependency Injection
└── Reactive State Updates

Local Storage Layer
├── Hive Database (Primary)
├── Secure Storage (Sensitive Data)
└── SharedPreferences (Settings)

Firebase Backend
├── Firestore (Database)
├── Authentication
├── Storage (Files)
├── Functions (Serverless)
├── AI Logic (Gemini)
└── Analytics/Crashlytics
```

## 🗺️ Implementation Roadmap

Cashense follows a comprehensive 32-task implementation plan organized into 3 phases:

### Phase 1: Foundation and Documentation (Tasks 1-6)
**Status: 85% Complete**

Foundation-first approach ensuring solid infrastructure before feature development:
- ✅ **Task 1**: Comprehensive project documentation with architecture guides
- ✅ **Task 2**: Strategic project setup with Flutter, Firebase, and development tools
- ✅ **Task 3**: Material 3 theming system with financial app-specific colors
- ✅ **Task 4**: Multi-language localization for 7 languages with RTL support
- ⏳ **Task 5**: Multi-currency foundation with real-time exchange rates
- ⏳ **Task 6**: Comprehensive utilities and optimized asset management

### Phase 2: Parallel Development Streams (Tasks 7-23)
**Status: 0% Complete**

Three parallel development streams for efficient team collaboration:

**Stream 1: Core Infrastructure & Authentication (Tasks 7-11)**
- Core data models with Freezed and code generation
- Local storage foundation with Hive encryption
- Firebase authentication with biometric support
- Riverpod state management setup
- End-to-end security implementation

**Stream 2: Financial Data Management (Tasks 12-17)**
- Multi-cashbook management with role-based permissions
- Hierarchical account structure (3 levels deep)
- Comprehensive transaction management with AI categorization
- Budget management with intelligent tracking and alerts
- Savings goals and financial planning tools
- Advanced analytics and reporting with export capabilities

**Stream 3: Advanced Features & Integration (Tasks 18-23)**
- AI-powered natural language processing for transaction entry
- Advanced transaction features (GPS, receipts, bulk operations)
- Social finance and group expense management
- Loan and debt tracking with flexible settlement options
- Investment portfolio tracking with real-time market data
- Bank integration with automatic transaction import

### Phase 3: Integration and Advanced Features (Tasks 24-32)
**Status: 0% Complete**

Final integration and polish for production readiness:
- Subscription and recurring transaction management
- Advanced notification system with predictive alerts
- Data import/export and migration tools
- Real-time cross-platform synchronization
- Responsive UI with accessibility support
- Performance optimization and comprehensive testing
- Deployment and DevOps setup
- Final integration and user onboarding

### Development Approach
- **Cost-Optimized**: Target $0-10/month operational costs using Firebase free tiers
- **AI-Powered**: Natural language processing and intelligent categorization
- **Offline-First**: Full functionality with local storage and seamless sync
- **Multi-Platform**: Single Flutter codebase for mobile, web, and desktop
- **Social Finance**: Group expense sharing and debt settlement optimization

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable) - managed via FVM
- Firebase CLI
- Git
- IDE: VS Code or Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/cashense.git
   cd cashense
   ```

2. **Set up Flutter version**
   ```bash
   # Install FVM if not already installed
   dart pub global activate fvm
   
   # Use project Flutter version
   fvm use
   fvm flutter --version
   ```

3. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

4. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase (if not already done)
   firebase init
   ```

5. **Configure Firebase**
   - Set up Firebase project with Firestore, Authentication, Storage, Functions, and Hosting
   - Configure `lib/firebase_options.dart` with your project settings
   - Ensure all Firebase services are enabled in your project

6. **Generate Code**
   ```bash
   fvm flutter packages pub run build_runner build
   ```

7. **Run the application**
   ```bash
   # Mobile
   fvm flutter run
   
   # Web
   fvm flutter run -d chrome
   
   # Desktop
   fvm flutter run -d windows  # or macos/linux
   ```

## 📱 Platform-Specific Setup

### Mobile Development

**Android:**
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions: Camera, Location, Biometric, Internet

**iOS:**
- Minimum iOS: 12.0
- Required capabilities: Camera, Location, FaceID/TouchID

### Web Development

- Hosted on Firebase Hosting
- PWA capabilities enabled
- Responsive design for all screen sizes
- Offline functionality with service workers

### Desktop Development

- Windows: Windows 10 or later
- macOS: macOS 10.14 or later  
- Linux: Ubuntu 18.04 or later

## 🔄 Recent Architecture Migration

Cashense has successfully migrated from Clean Architecture to Flutter's recommended MVVM (Model-View-ViewModel) pattern. This migration provides:

### Key Changes
- **Simplified Structure**: Consolidated data/domain/presentation layers into models/views/viewmodels
- **Direct Service Calls**: Eliminated repository abstraction layer for better performance
- **Feature-Based Organization**: Maintained logical grouping within MVVM structure
- **Enhanced Developer Experience**: More intuitive Flutter development patterns

### Migration Benefits
- ✅ Reduced code complexity and boilerplate
- ✅ Improved maintainability and navigation
- ✅ Better testability with focused scope
- ✅ Faster development cycles
- ✅ Preserved all existing functionality

### Updated Structure
```
lib/
├── models/          # Data models with business logic
├── views/           # UI components and pages  
├── viewmodels/      # State management with Riverpod
├── services/        # Core services (unchanged)
├── utils/           # Utilities and helpers
└── constants/       # App constants
```

## 🛠️ Development Workflow

### Enhanced Error Handling & App Initialization

Cashense implements comprehensive error handling throughout the application:

**Global Error Boundary:**
- Centralized error handling with `runZonedGuarded` for uncaught exceptions
- Flutter error boundary with custom error widgets
- Graceful error recovery with user-friendly error screens
- Comprehensive error logging with Crashlytics integration

**App Initialization:**
- Robust Firebase initialization with timeout and retry logic
- Proper service initialization order with error recovery
- SharedPreferences initialization with retry mechanism
- DevicePreview integration for enhanced debug experience

**Error Recovery Patterns:**
```dart
// Global error handling in main.dart
await runZonedGuarded<Future<void>>(
  () async {
    await _initializeApp();
  },
  (error, stack) => _handleGlobalError(error, stack),
);
```

### Advanced Theming System

Cashense features a sophisticated Material 3 theming system:

**Dynamic Color Support:**
- Material You dynamic color integration with `DynamicColorBuilder`
- Automatic light/dark theme generation from seed colors
- Custom financial color palette for expense tracking

**FinancialColors Extension:**
```dart
// Access financial-specific colors
final theme = Theme.of(context);
final financialColors = theme.financialColors;

// Use in widgets
Container(
  color: financialColors.income,  // Green for income
  child: Text('Income: \$1,234'),
)
```

**Theme Persistence:**
- Theme mode persistence with SharedPreferences
- Reactive theme switching with Riverpod state management
- System theme detection and automatic switching

**Available Financial Colors:**
- `income` - Green for income transactions
- `expense` - Red for expense transactions  
- `investment` - Purple for investment tracking
- `savings` - Blue for savings goals
- `success`, `warning`, `info` - Status indicators

### Code Organization

The project follows Flutter's recommended MVVM (Model-View-ViewModel) architecture pattern for simplified development and maintenance:

```
lib/
├── main.dart                          # App entry point
├── app/                              # App-level configuration
│   ├── router/                       # Navigation configuration
│   ├── theme/                        # Theme configuration
│   └── localization/                 # Localization setup
├── models/                           # Data models and business entities
│   ├── shared/                       # Shared data models
│   └── features/                     # Feature-specific models
│       ├── auth/                     # Authentication models
│       ├── settings/                 # Settings models
│       └── [other features]/        # Additional feature models
├── views/                            # UI components and pages
│   ├── shared/                       # Shared UI components
│   └── features/                     # Feature-specific views
│       ├── auth/                     # Authentication pages
│       ├── settings/                 # Settings pages
│       └── [other features]/        # Additional feature views
├── viewmodels/                       # State management and business logic
│   ├── shared/                       # Shared view models
│   ├── features/                     # Feature-specific view models
│   │   ├── auth/                     # Authentication view models
│   │   ├── settings/                 # Settings view models
│   │   └── [other features]/        # Additional feature view models
│   └── providers.dart                # Riverpod provider exports
├── services/                         # Core services and integrations
│   ├── firebase_service.dart         # Firebase integration
│   ├── crashlytics_service.dart      # Error reporting
│   └── [other services]/            # Additional services
├── utils/                            # Utility functions and helpers
│   ├── exceptions.dart               # Custom exceptions
│   └── [other utilities]/           # Additional utilities
├── constants/                        # App constants and configuration
└── l10n/                            # Localization files
```

### Constants Organization

Cashense uses a well-organized constants structure for maintainability:

```dart
// App metadata and configuration
AppConstants.appName        // "Cashense"
AppConstants.appVersion     // "1.0.0"
AppConstants.baseUrl        // API base URL

// UI constants for consistent spacing
UIConstants.defaultPadding  // 16.0
UIConstants.defaultBorderRadius // 12.0
UIConstants.mediumAnimation // 300ms

// Financial business logic
FinancialConstants.defaultCurrency // "USD"
FinancialConstants.maxTransactionAmount // 999999999.99

// Validation rules
ValidationConstants.minPasswordLength // 8
ValidationConstants.maxTransactionDescriptionLength // 255

// Feature flags
FeatureFlags.enableBiometricAuth // true
FeatureFlags.enableAIInsights // true
```

### Development Commands

```bash
# Code generation (required for MVVM pattern)
fvm flutter packages pub run build_runner build

# Watch mode for continuous code generation
fvm flutter packages pub run build_runner watch

# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Run tests (updated for MVVM structure)
fvm flutter test

# Run specific test categories
fvm flutter test test/models/        # Model tests
fvm flutter test test/viewmodels/    # ViewModel tests
fvm flutter test test/views/         # Widget tests
fvm flutter test test/integration/   # Integration tests

# Analyze code
fvm flutter analyze

# Format code
fvm flutter format .

# Generate documentation
dart doc

# Build for production
fvm flutter build apk --release      # Android
fvm flutter build ios --release      # iOS
fvm flutter build web --release      # Web
fvm flutter build windows --release  # Windows
fvm flutter build macos --release    # macOS
fvm flutter build linux --release    # Linux
```

### Development Tools

**Model Context Protocol (MCP) Integration:**
- **GitMCP Server**: Currently configured for AI-assisted Git operations and repository analysis
  - Enables intelligent Git workflow assistance through Kiro AI assistant
  - Configured at user level (`~/.kiro/settings/mcp.json`) for cross-project availability
  - Provides contextual repository insights and code analysis
  - Command: `npx mcp-remote https://gitmcp.io/{owner}/{repo}`
- **Sequential Thinking MCP**: Advanced reasoning capabilities for complex problem-solving
  - Provides structured thinking processes for development decisions
  - Command: `npx -y @modelcontextprotocol/server-sequential-thinking`
  - Enables multi-step analysis and solution development
- **Flutter Inspector MCP**: Available for enhanced debugging capabilities
  - Real-time widget tree inspection and performance analysis via `flutter-mcp` package
  - AI-assisted development environment for improved productivity and debugging workflows
  - Connects to Dart VM (localhost:8181) for live application debugging during development
  - Integrated resource inspection and image analysis capabilities

### Git Workflow

1. Create feature branch from `develop`
2. Make changes following coding standards
3. Run tests and ensure code quality
4. Create pull request with detailed description
5. Code review and approval required
6. Merge to `develop` branch

## 🧪 Testing Strategy

### Test Types

- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI components and interactions
- **Integration Tests**: Complete user workflows
- **Performance Tests**: Memory usage and rendering

### Running Tests

```bash
# All tests
fvm flutter test

# Specific test file
fvm flutter test test/features/transactions/transaction_service_test.dart

# Integration tests
fvm flutter test integration_test/

# Test coverage
fvm flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔧 Configuration

### Project Dependencies

The project is configured with comprehensive dependencies for:

**Core Framework:**
- Flutter SDK (^3.8.1) with FVM management
- Material 3 design system with dynamic theming
- Cross-platform support (mobile, web, desktop)

**State Management:**
- Riverpod (^2.6.1) for compile-time safe providers
- Advanced async/sync state management

**Firebase Integration:**
- Complete Firebase suite (Core, Auth, Firestore, Storage, Analytics, Crashlytics, Messaging, Functions)
- Real-time synchronization and offline capabilities

**Local Storage:**
- Hive (^2.2.3) for primary local database
- flutter_secure_storage for sensitive data encryption
- SharedPreferences for app settings

**UI & Navigation:**
- go_router (^16.0.0) for declarative navigation
- fl_chart for financial data visualization
- flutter_form_builder for complex forms
- dynamic_color for Material You theming

**Localization & Utilities:**
- Multi-language support with flutter_localizations
- Currency handling with currency_picker and money2
- Network requests with dio
- Text-to-speech capabilities with flutter_tts

### Environment Variables

Create `.env` files for different environments:

```bash
# .env.development
FIREBASE_PROJECT_ID=cashense-dev
API_BASE_URL=https://api-dev.cashense.com
ENABLE_ANALYTICS=false

# .env.production  
FIREBASE_PROJECT_ID=cashense-prod
API_BASE_URL=https://api.cashense.com
ENABLE_ANALYTICS=true
```

### Firebase Configuration

Key Firebase services configured:
- **Firestore**: Primary database (1GB + 50K reads/20K writes free)
- **Authentication**: User management (50K MAU free)
- **Storage**: File attachments (5GB free)
- **Functions**: Serverless backend logic (2M invocations/month free)
- **Hosting**: Web deployment (10GB storage + 360MB/day transfer free)
- **Analytics**: User behavior tracking and insights
- **Crashlytics**: Error reporting and crash analysis
- **Messaging**: Push notifications for alerts and updates

## 🌍 Localization

Supported languages:
- English (en_US) - Default
- Spanish (es_ES)
- French (fr_FR)
- German (de_DE)
- Arabic (ar_SA) - RTL support
- Hindi (hi_IN)
- Chinese (zh_CN)

### Adding New Translations

1. Add strings to `l10n/app_en.arb`
2. Generate translations for other languages
3. Run code generation: `fvm flutter gen-l10n`
4. Use in code: `context.l10n.stringKey`

## 💰 Business Model & Cost Optimization

Cashense follows a freemium model leveraging Firebase free tiers:

**Target Monthly Costs: $0-10**

- Firestore: 1GB storage + 50K reads/20K writes (free)
- Authentication: 50K monthly active users (free)
- Storage: 5GB storage (free)
- Functions: 2M invocations/month (free)
- Hosting: 10GB storage + 360MB/day transfer (free)

Premium features will be available for advanced analytics and integrations while maintaining cost efficiency within Firebase limits.

## 🔒 Security

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

### Privacy
- GDPR compliance with data export/deletion
- Local-first data storage options
- Granular privacy controls
- Data anonymization features

## 📊 Performance

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

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch
3. Follow coding standards
4. Add tests for new features
5. Submit a pull request

## 📚 Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Testing Guide](docs/TESTING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🐛 Troubleshooting

### Common Issues

**Build Errors:**
```bash
# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Firebase Connection Issues:**
- Verify Firebase configuration in `lib/firebase_options.dart`
- Check internet connectivity
- Ensure Firebase services are enabled

**Performance Issues:**
- Check for memory leaks in providers
- Optimize image loading and caching
- Review Firestore query efficiency

**Error Handling Issues:**
- **Global Errors**: Check `main.dart` for proper error boundary setup
- **Theme Errors**: Verify `ThemeModeNotifier` initialization in providers
- **Crashlytics**: Ensure Crashlytics is properly initialized for error reporting
- **Error Recovery**: Use the built-in error recovery mechanisms in `_ErrorScreen`

**Theme and UI Issues:**
- **Dynamic Colors**: Ensure `DynamicColorBuilder` is properly configured
- **Financial Colors**: Access via `Theme.of(context).financialColors`
- **Theme Persistence**: Check SharedPreferences initialization
- **Material 3**: Verify `useMaterial3: true` in theme configuration

**Development Tools Issues:**
- **GitMCP**: Verify `mcp-remote` is installed: `npm install -g mcp-remote`
- **Sequential Thinking MCP**: Test server: `npx -y @modelcontextprotocol/server-sequential-thinking`
- **Flutter Inspector MCP**: Ensure Dart VM is running on localhost:8181 for live debugging
- **MCP Configuration**: Check MCP server configuration in `.kiro/settings/mcp.json`
- **Connectivity**: Test MCP server connectivity: `npx flutter-mcp --stdio` (for Flutter Inspector)
- **Restart**: Restart Kiro if MCP server connection fails after configuration changes

**MVVM Migration Issues:**
- **Code Generation**: Run `fvm flutter packages pub run build_runner build` after any model changes
- **Import Errors**: Use barrel exports from `models/index.dart`, `views/index.dart`, `viewmodels/index.dart`
- **Provider Issues**: Check `viewmodels/providers.dart` for correct provider configuration
- **State Management**: Ensure ViewModels extend StateNotifier and use AsyncValue pattern

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Target Users

- Individuals seeking comprehensive personal finance management
- Families managing shared expenses and budgets
- Small businesses tracking expenses and cash flow
- Groups sharing expenses (roommates, travel, events)
- Anyone wanting AI-assisted financial insights

## 📊 Implementation Progress

### Phase 1: Foundation and Documentation (85% Complete)
- ✅ **Comprehensive Project Documentation** - Complete README, CONTRIBUTING, ARCHITECTURE, API docs
- ✅ **Strategic Project Setup** - Flutter with FVM, Firebase integration, pubspec configuration
- ✅ **Foundation-First Theming** - Material 3 with dynamic colors, financial color system
- ✅ **Comprehensive Localization** - 7-language support with ARB files and RTL
- ⏳ **Multi-Currency Foundation** - Real-time exchange rates and conversion services
- ⏳ **Utilities and Assets Setup** - Asset management and performance optimization

### Phase 2: Parallel Development Streams (0% Complete)
- **Stream 1: Core Infrastructure & Authentication** - Data models, local storage, auth service
- **Stream 2: Financial Data Management** - Cashbooks, accounts, transactions, budgets
- **Stream 3: Advanced Features & Integration** - AI/NLP, social finance, bank integration

### Phase 3: Integration and Advanced Features (0% Complete)
- Advanced notifications, data import/export, cross-platform sync, final polish

### Overall Project Progress: 25% Complete

## 📊 Success Metrics

- User engagement and retention
- Transaction volume and accuracy
- Cost efficiency within Firebase limits
- Cross-platform adoption rates

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the comprehensive backend services
- Riverpod for excellent state management
- Material Design team for design guidelines
- Open source community for various packages used

## 📞 Support

- **Documentation**: Check the docs/ directory
- **Issues**: Create a GitHub issue
- **Discussions**: Use GitHub Discussions
- **Email**: support@cashense.com

---

**Built with ❤️ using Flutter and Firebase**