# Getting Started with Cashense

This guide provides step-by-step instructions for setting up your development environment and getting started with the Cashense project.

## Prerequisites

Before you begin, make sure you have the following installed:

1. **Flutter SDK**:
   - Install [Flutter](https://flutter.dev/docs/get-started/install)
   - We use Flutter Version Management (FVM) - install it with `dart pub global activate fvm`

2. **Development Tools**:
   - [VS Code](https://code.visualstudio.com/) with Flutter extension or [Android Studio](https://developer.android.com/studio) with Flutter plugin
   - [Git](https://git-scm.com/downloads)

3. **Supabase Account**:
   - Sign up for a [Supabase](https://supabase.com/) account
   - You'll need this for backend development and testing

4. **API Keys**:
   - OpenAI API key (for AI features)
   - Firebase project credentials (for notifications)

## Setting Up Your Development Environment

### 1. Clone the Repository

```bash
git clone https://github.com/UTTAM-VAGHASIA/cashense.git
cd cashense
```

### 2. Install the Correct Flutter Version

```bash
fvm install
fvm use
```

This will install and use the Flutter version specified in the `.fvmrc` file.

### 3. Install Dependencies

```bash
fvm flutter pub get
```

### 4. Set Up Supabase

1. Create a new Supabase project from the [Supabase Dashboard](https://app.supabase.io/)
2. Execute the database schema scripts found in `docs/database/setup_scripts.sql`
3. Configure Row-Level Security (RLS) policies as per the schema documentation
4. Create a `.env` file in the project root (copy from `.env.example`):

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
OPENAI_API_KEY=your_openai_key
FIREBASE_WEB_CONFIG=your_firebase_web_config_json
```

### 5. Set Up Firebase (for Notifications)

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your Firebase project
3. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

### 6. Configure IDE

#### VS Code Setup

Install the following extensions:
- Flutter
- Dart
- Flutter Riverpod Snippets
- bloc
- Error Lens

Enable format on save and lint on save in your settings:

```json
{
  "editor.formatOnSave": true,
  "dart.lineLength": 80,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

#### Android Studio Setup

Install the following plugins:
- Flutter
- Dart
- Flutter Riverpod Snippets

Enable format on save in Settings > Editor > Code Style > Dart > Format on Save

### 7. Run the App

```bash
fvm flutter run
```

This will run the app on a connected device or simulator.

## Project Structure

The project follows a feature-first architecture. Key directories include:

```
lib/
├── core/             # Core utilities and constants
├── data/             # Data models and repositories
├── domain/           # Business logic and entities
├── features/         # Feature modules
├── presentation/     # UI components
├── routes/           # App routing
└── main.dart         # App entry point
```

For a more detailed overview, see [Project Structure](../project_structure.md).

## Development Workflow

### 1. Git Workflow

We follow the GitFlow workflow:

1. Create a feature branch from `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit regularly:
   ```bash
   git add .
   git commit -m "feat: your meaningful commit message"
   ```

3. Push your changes:
   ```bash
   git push -u origin feature/your-feature-name
   ```

4. Create a pull request to merge into `develop`

### 2. Adding New Features

When adding a new feature:

1. Create a new feature directory in `lib/features/`
2. Follow the structure outlined in the [Coding Standards](coding_standards.md)
3. Add routes in `lib/routes/` if creating new screens
4. Add tests for your feature

### 3. Running Tests

```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run specific tests
fvm flutter test test/features/your_feature
```

### 4. Building for Release

```bash
# Android
fvm flutter build apk --release

# iOS
fvm flutter build ios --release
```

## Working with Supabase

### Local Development

For local development, you can:

1. Use the actual Supabase project (recommended for teams)
2. Use Supabase Local Development:
   ```bash
   supabase start
   ```

### Database Migrations

We manage database changes through SQL migration files in `supabase/migrations/`.

To create a new migration:

1. Create a new SQL file in the migrations directory:
   ```bash
   echo "-- Your SQL statements here" > supabase/migrations/$(date +%Y%m%d%H%M%S)_your_migration_name.sql
   ```

2. Apply the migration to your local Supabase instance:
   ```bash
   supabase db reset
   ```

3. Commit the migration file to the repository

## Working with AI Features

The AI features utilize OpenAI's API. To work on AI features:

1. Make sure your `.env` file has a valid `OPENAI_API_KEY`
2. Use the provided AI service in `lib/core/services/ai_service.dart`
3. Be mindful of API usage costs during development

## Troubleshooting

### Common Issues

1. **Flutter Version Mismatch**:
   ```bash
   fvm install
   fvm use
   ```

2. **Dependency Issues**:
   ```bash
   fvm flutter clean
   fvm flutter pub get
   ```

3. **Supabase Connection Issues**:
   - Verify your `.env` file has the correct credentials
   - Ensure your IP is whitelisted in Supabase

4. **Build Failures**:
   - Check the error message for specific issues
   - Try `flutter clean` and rebuild

### Getting Help

If you encounter issues:

1. Check the [project documentation](../index.md)
2. Review the [Flutter documentation](https://flutter.dev/docs)
3. Contact the project maintainers:
   - [Maintainer Name](mailto:maintainer@example.com)

## Resources

### Documentation

- [Cashense Documentation](../index.md)
- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.io/docs)
- [Riverpod Documentation](https://riverpod.dev/docs)

### Learning Resources

- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Supabase Flutter Tutorial](https://supabase.com/docs/guides/with-flutter)
- [Riverpod Examples](https://github.com/rrousselGit/riverpod/tree/master/examples)

## Next Steps

Now that you've set up your development environment, you can:

1. Review the [Project Roadmap](../project_roadmap.md)
2. Check the [Implementation Plan](../implementation_plan.md)
3. Start working on [Phase 1: Core Foundation](../phase_details/phase1_core_foundation.md) 
