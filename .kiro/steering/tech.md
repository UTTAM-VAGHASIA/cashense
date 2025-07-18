# Cashense Technology Stack

## Framework & Platform
- **Flutter SDK**: Latest stable version managed via FVM (Flutter Version Management)
- **Target Platforms**: Mobile (iOS/Android), Web (PWA), Desktop (Windows/Mac/Linux)
- **UI Framework**: Material 3 design system for consistent cross-platform experience

## State Management
- **Primary**: Riverpod for compile-time safe providers and advanced async/sync state management
- **Fallback**: Provider for simpler use cases

## Backend & Database (Firebase-Only)
- **Firestore**: Primary database (1GB + 50K reads/20K writes free tier)
- **Firebase Authentication**: User management (50K MAU free)
- **Firebase Storage**: File attachments (5GB free)
- **Firebase Functions**: Serverless backend logic (2M invocations/month free)
- **Firebase Hosting**: Web deployment (10GB storage + 360MB/day transfer free)

## Local Storage
- **Hive**: Primary local database for mobile/desktop/web (faster than Isar, simpler API)
- **flutter_secure_storage**: Sensitive data encryption
- **SharedPreferences**: App settings and preferences

## AI/ML Integration
- **Firebase AI Logic**: Vertex AI integration for intelligent categorization
- **Gemini in Firebase**: Contextual awareness and insights
- **OpenAI API**: Advanced NLP processing (pay-per-use, cost-optimized)
- **Local alternatives**: flutter_tts + speech_to_text for offline voice features

## Development Tools
- **FVM**: Flutter version management
- **Firebase CLI**: Backend management
- **build_runner**: Code generation
- **Git**: Version control with Git Flow branching strategy

## Common Commands

### Setup
```bash
# Install FVM and use project Flutter version
dart pub global activate fvm
fvm use
fvm flutter --version

# Install dependencies
fvm flutter pub get

# Generate code
fvm flutter packages pub run build_runner build
```

### Development
```bash
# Run app (mobile)
fvm flutter run

# Run web
fvm flutter run -d chrome

# Run desktop
fvm flutter run -d windows  # or macos/linux

# Hot reload code generation
fvm flutter packages pub run build_runner watch
```

### Testing & Quality
```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Analyze code
fvm flutter analyze

# Format code
fvm flutter format .
```

### Building
```bash
# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for production
fvm flutter build apk --release      # Android
fvm flutter build ios --release      # iOS
fvm flutter build web --release      # Web
fvm flutter build windows --release  # Windows
```

### Firebase
```bash
# Deploy web app
firebase deploy --only hosting

# Deploy functions
firebase deploy --only functions

# View logs
firebase functions:log
```

## Cost Optimization Strategy
- Leverage Firebase free tiers effectively
- Target monthly operational cost: $0-10
- Monitor usage with automated alerts
- Implement efficient Firestore queries with composite indexes
- Use local storage to minimize cloud reads/writes