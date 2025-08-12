# Design Document

## Overview

The Google Authentication system will replace the current `BiometricsPage` with a comprehensive authentication flow. The design leverages Firebase Authentication with Google Sign-In, utilizing the existing Firebase setup and the `google_sign_in_all_platforms` package for cross-platform compatibility. The system will implement a clean, Material You-compliant UI with proper state management using GetX.

## Architecture

### Authentication Flow
```
App Launch → Check Auth State → [Authenticated] → Welcome Screen
                              → [Not Authenticated] → Login Screen → Google OAuth → Firebase Auth → Welcome Screen
```

### Component Structure
```
AuthenticationController (GetX)
├── AuthenticationService (Firebase + Google Sign-In)
├── LoginScreen (UI)
├── WelcomeScreen (UI)
└── AuthenticationBinding (Dependency Injection)
```

## Components and Interfaces

### 1. AuthenticationController
**Purpose:** Manages authentication state and business logic using GetX
**Key Methods:**
- `signInWithGoogle()`: Initiates Google Sign-In flow
- `signOut()`: Signs out the user
- `checkAuthState()`: Checks current authentication status
- `getCurrentUser()`: Returns current user information

**State Variables:**
- `isLoading`: Boolean for loading states
- `user`: Current Firebase user object
- `isAuthenticated`: Authentication status
- `errorMessage`: Error message for UI display

### 2. AuthenticationService
**Purpose:** Handles Firebase and Google Sign-In integration
**Key Methods:**
- `signInWithGoogle()`: Performs Google OAuth and Firebase authentication
- `signOut()`: Signs out from both Google and Firebase
- `getCurrentUser()`: Gets current Firebase user
- `isUserSignedIn()`: Checks authentication status

**Platform Handling:**
- Android: Native Google Sign-In
- Web/Desktop: Web-based OAuth flow
- iOS: Placeholder for future implementation

### 3. LoginScreen
**Purpose:** Material You-compliant login interface
**Components:**
- Cashense logo/branding
- "Sign in with Google" button with Google logo
- Loading indicator during authentication
- Error message display
- Responsive layout for different screen sizes

### 4. WelcomeScreen
**Purpose:** Post-authentication welcome interface
**Components:**
- Welcome message with user's name
- User profile picture (optional)
- Navigation to main app (placeholder for now)
- Sign out option

### 5. AuthenticationBinding
**Purpose:** GetX dependency injection setup
**Responsibilities:**
- Initialize AuthenticationController
- Initialize AuthenticationService
- Set up dependencies for authentication flow

## Data Models

### User Model
```dart
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  
  // Constructor and methods
}
```

### Authentication State
```dart
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error
}
```

## Error Handling

### Error Categories
1. **Network Errors**: Poor connectivity, timeouts
2. **Google Sign-In Errors**: User cancellation, service unavailable
3. **Firebase Errors**: Authentication failures, configuration issues
4. **Platform Errors**: Platform-specific issues

### Error Handling Strategy
- Log all errors with appropriate detail using existing `AppLogger`
- Display user-friendly error messages
- Implement retry mechanisms for network issues
- Graceful degradation for platform-specific failures

### Error Messages
- Generic: "Something went wrong. Please try again."
- Network: "Please check your internet connection and try again."
- Cancelled: No error message (return to login screen)
- Service Unavailable: "Google Sign-In is temporarily unavailable."

## Testing Strategy

### Unit Tests
- AuthenticationController methods
- AuthenticationService methods
- User model validation
- Error handling scenarios

### Widget Tests
- LoginScreen UI components
- WelcomeScreen UI components
- Button interactions
- Loading states
- Error message display

### Integration Tests
- Complete authentication flow
- Platform-specific sign-in flows
- State persistence
- Navigation between screens

### Platform Testing
- Android: Native Google Sign-In
- Web: Web OAuth flow
- Windows: Desktop web flow
- Linux: Desktop web flow
- macOS: Desktop web flow

## Platform-Specific Considerations

### Android
- Use native Google Sign-In SDK
- Configure `google-services.json`
- Set up SHA-1 fingerprints in Firebase Console

### Web
- Configure web OAuth client ID
- Set up authorized domains in Google Cloud Console
- Handle web-specific redirect flows

### Desktop (Windows, Linux, macOS)
- Use web-based OAuth flow
- Handle desktop browser integration
- Manage redirect URL handling

### iOS (Future Implementation)
- Will require iOS-specific Google Sign-In configuration
- Apple Developer account setup
- iOS-specific Firebase configuration

## Security Considerations

### Authentication Security
- Use Firebase Authentication for secure token management
- Implement proper token refresh mechanisms
- Store authentication state securely using Flutter Secure Storage

### Data Protection
- Never store sensitive authentication data locally
- Use secure HTTP connections only
- Implement proper session management

## UI/UX Design Specifications

### Login Screen Design
- **Layout**: Centered content with Cashense branding at top
- **Colors**: Material You dynamic colors with brand accent
- **Typography**: Use existing font hierarchy (Avenir/Inter)
- **Button**: Elevated button with Google logo and "Sign in with Google" text
- **Spacing**: Generous whitespace following Material Design guidelines
- **Responsive**: Adapt to different screen sizes and orientations

### Welcome Screen Design
- **Layout**: Centered welcome message with user information
- **Greeting**: "Welcome back, [User Name]!" or "Welcome to Cashense!"
- **Profile**: Optional user profile picture
- **Actions**: Sign out button in app bar
- **Transition**: Smooth navigation from login screen

### Loading States
- **Login**: Show loading indicator on button during authentication
- **Screen**: Full-screen loading indicator during initial auth check
- **Feedback**: Haptic feedback on successful authentication

### Dark Mode Support
- Automatic adaptation to system theme
- Proper contrast ratios for accessibility
- Consistent branding colors in both themes