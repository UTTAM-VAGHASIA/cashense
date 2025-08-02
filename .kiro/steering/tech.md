# Cashense Technology Stack

## Framework & Architecture

- **Flutter SDK**: Latest stable version managed via FVM (Flutter Version Management)
- **Architecture Pattern**: MVVM (Model-View-ViewModel) - recently migrated from Clean Architecture
- **State Management**: Riverpod (^2.6.1) for compile-time safe providers and reactive state
- **Design System**: Material 3 with dynamic color theming

## Backend & Services

### Firebase Suite (Primary Backend)
- **Firestore**: Primary database (1GB + 50K reads/20K writes free)
- **Authentication**: User management (50K MAU free)
- **Storage**: File attachments (5GB free)
- **Functions**: Serverless backend logic (2M invocations/month free)
- **Hosting**: Web deployment (10GB storage + 360MB/day transfer free)
- **Analytics**: User behavior tracking and insights
- **Crashlytics**: Error reporting and crash analysis
- **Messaging**: Push notifications and real-time alerts

### AI Integration
- **Firebase AI Logic**: Vertex AI integration for intelligent categorization
- **Gemini**: Contextual awareness and insights
- **Natural Language Processing**: Transaction parsing and voice input

## Local Storage

- **Hive** (^2.2.3): Primary local database for offline-first functionality
- **flutter_secure_storage** (^9.2.4): Sensitive data encryption
- **SharedPreferences** (^2.5.3): App settings and preferences

## Key Dependencies

### Navigation & UI
- **go_router** (^16.0.0): Declarative navigation
- **fl_chart** (^1.0.0): Financial data visualization
- **flutter_form_builder** (^10.1.0): Complex forms
- **dynamic_color** (^1.7.0): Material You theming

### Utilities
- **currency_picker** (^2.0.21): Multi-currency support
- **money2** (^6.0.3): Currency handling and calculations
- **dio** (^5.8.0+1): Network requests
- **uuid** (^4.5.1): Unique identifier generation

### Code Generation
- **build_runner** (^2.4.13): Code generation runner
- **freezed** (^3.0.0): Immutable data classes
- **json_serializable** (^6.8.0): JSON serialization
- **hive_generator** (^2.0.1): Hive type adapters

## Development Tools

### Code Quality
- **flutter_lints** (^6.0.0): Comprehensive linting rules
- **analysis_options.yaml**: Strict analysis configuration with financial app security focus

### Testing
- **flutter_test**: Widget and unit testing
- **integration_test**: End-to-end testing

### Model Context Protocol (MCP)
- **Context 7**: Get latest documentation for any library or dependency or framework
- **GitMCP Server**: Repository analysis and Git operations
- **Sequential Thinking MCP**: Advanced reasoning for complex problems
- **Flutter Inspector MCP**: Real-time debugging and widget inspection

## Common Commands

### Development Workflow
```bash
# Setup project
fvm use
fvm flutter pub get

# Code generation (required after model changes)
fvm dart run build_runner build

# Watch mode for continuous generation
fvm dart run build_runner watch

# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
fvm flutter test

# Run specific test categories
fvm flutter test test/models/        # Model tests
fvm flutter test test/viewmodels/    # ViewModel tests
fvm flutter test test/views/         # Widget tests
fvm flutter test test/integration/   # Integration tests

# Test with coverage
fvm flutter test --coverage
```

### Platform Builds
```bash
# Development builds
fvm flutter run                      # Default platform
fvm flutter run -d chrome           # Web
fvm flutter run -d windows          # Desktop

# Production builds
fvm flutter build apk --release     # Android
fvm flutter build ios --release     # iOS
fvm flutter build web --release     # Web
fvm flutter build windows --release # Windows
```

### Code Quality
```bash
# Analyze code
fvm flutter analyze

# Format code
fvm dart format .

# Generate documentation
dart doc
```

## Platform Support

- **Mobile**: iOS 12.0+, Android API 21+
- **Web**: PWA with offline capabilities
- **Desktop**: Windows 10+, macOS 10.14+, Ubuntu 18.04+

## Performance Considerations

- Lazy loading for large datasets
- Image optimization and caching with cached_network_image
- Efficient Firestore queries with composite indexes
- Local storage optimization with automatic cleanup
- Progressive sync with priority-based updates