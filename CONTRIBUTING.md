# Contributing to Cashense

Thank you for your interest in contributing to Cashense! This document provides guidelines and information for contributors to ensure a smooth and productive development experience.

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- Be respectful and inclusive
- Focus on constructive feedback
- Help create a welcoming environment for all contributors
- Report any unacceptable behavior to the maintainers

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- Flutter SDK (managed via FVM)
- Firebase CLI
- Git knowledge
- IDE: VS Code or Android Studio
- Basic understanding of Dart/Flutter
- Familiarity with Firebase services

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/UTTAM-VAGHASIA/cashense.git
   cd cashense
   ```

2. **Set up Flutter**
   ```bash
   fvm use
   fvm flutter pub get
   ```

3. **Configure Firebase**
   - Set up your own Firebase project for development
   - Copy `firebase_options_template.dart` to `lib/firebase_options.dart`
   - Update with your Firebase configuration

4. **Generate Code**
   ```bash
   fvm flutter packages pub run build_runner build
   ```

5. **Run Tests**
   ```bash
   fvm flutter test
   ```

## 📋 Development Workflow

### Branch Strategy

We use Git Flow with the following branches:

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: Individual feature development
- `hotfix/*`: Critical bug fixes
- `release/*`: Release preparation

### Creating a Feature

1. **Create Feature Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Follow coding standards (see below)
   - Write tests for new functionality
   - Update documentation if needed

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   - Create Pull Request to `develop` branch
   - Fill out PR template completely

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(auth): add biometric authentication support
fix(transactions): resolve category selection bug
docs(readme): update installation instructions
test(budgets): add unit tests for budget service
```

## 🎯 Coding Standards

### Dart/Flutter Guidelines

**Code Style:**
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for consistent formatting
- Maximum line length: 80 characters
- Use meaningful variable and function names

**File Organization:**
```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

// 4. Local imports (alphabetical)
import '../models/user.dart';
import '../services/auth_service.dart';
```

**Class Structure:**
```dart
class ExampleClass {
  // 1. Static constants
  static const String defaultValue = 'default';
  
  // 2. Instance variables
  final String id;
  final String name;
  
  // 3. Constructor
  const ExampleClass({
    required this.id,
    required this.name,
  });
  
  // 4. Named constructors
  ExampleClass.empty() : this(id: '', name: '');
  
  // 5. Getters
  String get displayName => name.isEmpty ? 'Unknown' : name;
  
  // 6. Methods (public first, then private)
  void publicMethod() {
    // Implementation
  }
  
  void _privateMethod() {
    // Implementation
  }
}
```

### Architecture Patterns

**Feature Structure:**
```
features/feature_name/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── providers/
└── feature_name.dart
```

**Riverpod Providers:**
```dart
// Use appropriate provider types
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firebaseAuthProvider));
});

final userProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Use family providers for parameterized data
final transactionsProvider = FutureProvider.family<List<Transaction>, String>(
  (ref, cashbookId) async {
    return ref.read(transactionServiceProvider).getTransactions(cashbookId);
  },
);
```

**Error Handling:**
```dart
// Use Result pattern for error handling
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Exception error;
}

// Usage
Future<Result<User>> signIn(String email, String password) async {
  try {
    final user = await _authService.signIn(email, password);
    return Success(user);
  } catch (e) {
    return Failure(Exception('Sign in failed: $e'));
  }
}
```

### Testing Standards

**Test Structure:**
```dart
void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = AuthService(mockFirebaseAuth);
    });
    
    group('signIn', () {
      test('should return user when credentials are valid', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final mockUser = MockUser();
        
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => MockUserCredential(mockUser));
        
        // Act
        final result = await authService.signIn(email, password);
        
        // Assert
        expect(result, isA<Success<User>>());
        expect((result as Success<User>).data.email, equals(email));
      });
      
      test('should return failure when credentials are invalid', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';
        
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
        
        // Act
        final result = await authService.signIn(email, password);
        
        // Assert
        expect(result, isA<Failure<User>>());
      });
    });
  });
}
```

**Widget Testing:**
```dart
void main() {
  group('LoginPage', () {
    testWidgets('should display login form', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    
    testWidgets('should show error when login fails', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWith((ref) => MockAuthService()),
          ],
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // Act
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

## 📝 Documentation Standards

### Code Documentation

**Class Documentation:**
```dart
/// Service responsible for managing user authentication.
/// 
/// This service handles sign-in, sign-up, password reset, and session
/// management using Firebase Authentication. It provides a clean interface
/// for authentication operations throughout the application.
/// 
/// Example usage:
/// ```dart
/// final authService = ref.read(authServiceProvider);
/// final result = await authService.signIn('user@example.com', 'password');
/// ```
class AuthService {
  /// Signs in a user with email and password.
  /// 
  /// Returns a [Result] containing either the authenticated [User] on success
  /// or an [Exception] on failure.
  /// 
  /// Throws [ArgumentError] if [email] or [password] is empty.
  Future<Result<User>> signIn(String email, String password) async {
    // Implementation
  }
}
```

**Method Documentation:**
```dart
/// Calculates the hierarchical balance for an account including all sub-accounts.
/// 
/// This method recursively traverses the account hierarchy and sums up all
/// balances from the specified account and its children.
/// 
/// Parameters:
/// - [accountId]: The ID of the root account to calculate balance for
/// - [includeArchived]: Whether to include archived accounts in calculation
/// 
/// Returns the total balance as a [double] value.
/// 
/// Throws [AccountNotFoundException] if the account doesn't exist.
Future<double> calculateHierarchicalBalance(
  String accountId, {
  bool includeArchived = false,
}) async {
  // Implementation
}
```

### README Updates

When adding new features:

1. Update feature list in main README
2. Add configuration instructions if needed
3. Update troubleshooting section for common issues
4. Add examples for new APIs

## 🧪 Testing Requirements

### Test Coverage

- **Minimum Coverage**: 80% for new code
- **Critical Paths**: 95% coverage required
- **UI Components**: Widget tests for all custom widgets
- **Services**: Unit tests for all public methods

### Test Types Required

**For New Features:**
1. **Unit Tests**: Business logic and utilities
2. **Widget Tests**: UI components and interactions
3. **Integration Tests**: Complete user workflows
4. **Performance Tests**: For data-heavy operations

**Test Naming:**
```dart
// Unit tests
void main() {
  group('ClassName', () {
    group('methodName', () {
      test('should return expected result when valid input provided', () {
        // Test implementation
      });
      
      test('should throw exception when invalid input provided', () {
        // Test implementation
      });
    });
  });
}

// Widget tests
void main() {
  group('WidgetName', () {
    testWidgets('should display correct content when data is available', (tester) async {
      // Test implementation
    });
    
    testWidgets('should show loading indicator when data is loading', (tester) async {
      // Test implementation
    });
  });
}
```

## 🔍 Code Review Process

### Before Submitting PR

**Self-Review Checklist:**
- [ ] Code follows style guidelines
- [ ] All tests pass locally
- [ ] New features have adequate test coverage
- [ ] Documentation is updated
- [ ] No console errors or warnings
- [ ] Performance impact considered
- [ ] Security implications reviewed

### PR Requirements

**PR Template:**
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots for UI changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests pass locally
- [ ] Documentation updated
```

### Review Criteria

**Code Quality:**
- Readability and maintainability
- Performance considerations
- Security best practices
- Error handling
- Test coverage

**Architecture:**
- Follows established patterns
- Proper separation of concerns
- Appropriate use of design patterns
- Integration with existing codebase

## 🐛 Bug Reports

### Bug Report Template

```markdown
**Bug Description**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected Behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15.0, Android 12]
- App Version: [e.g. 1.2.0]
- Flutter Version: [e.g. 3.16.0]

**Additional Context**
Add any other context about the problem here.
```

## 🚀 Feature Requests

### Feature Request Template

```markdown
**Feature Description**
A clear and concise description of the feature you'd like to see.

**Problem Statement**
What problem does this feature solve? Who would benefit from it?

**Proposed Solution**
Describe your proposed solution in detail.

**Alternatives Considered**
Describe any alternative solutions you've considered.

**Additional Context**
Add any other context, mockups, or examples about the feature request.
```

## 📚 Resources

### Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design Guidelines](https://material.io/design)

### Development Tools

- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Firebase Console](https://console.firebase.google.com/)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## 🙋‍♀️ Getting Help

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and discussions
- **Code Reviews**: PR comments and suggestions
- **Documentation**: Check docs/ directory first

### Response Times

- **Bug Reports**: 24-48 hours
- **Feature Requests**: 1-2 weeks
- **Pull Requests**: 2-3 business days
- **Questions**: 24-48 hours

## 🎉 Recognition

Contributors will be recognized in:

- README.md contributors section
- Release notes for significant contributions
- GitHub contributor graphs
- Special mentions for outstanding contributions

Thank you for contributing to Cashense! Your efforts help make financial management accessible and intelligent for everyone. 🚀