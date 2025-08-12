import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:flutter/foundation.dart';
import 'package:cashense/features/authentication/models/app_user.dart';
import 'package:cashense/utils/logging/logger.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/data/services/platform_auth_config.dart';

/// Service class handling authentication operations with Firebase and Google Sign-In
class AuthenticationService {
  static final AuthenticationService _instance =
      AuthenticationService._internal();
  factory AuthenticationService() => _instance;
  AuthenticationService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;

  /// Initialize Google Sign-In with platform-specific configuration
  void _initializeGoogleSignIn() {
    if (_googleSignIn != null) return;

    try {
      // Log platform configuration details
      PlatformAuthConfig.logPlatformConfiguration();

      // Validate platform configuration
      if (!PlatformAuthConfig.validatePlatformConfiguration()) {
        AppLogger.error('Platform configuration validation failed');
        return;
      }

      // Check if Google Sign-In is supported on current platform
      if (!PlatformAuthConfig.isGoogleSignInSupported()) {
        AppLogger.auth('Google Sign-In not supported on current platform');
        return;
      }

      // Platform-specific configuration
      if (kIsWeb) {
        // Web configuration
        _googleSignIn = GoogleSignIn(
          params: GoogleSignInParams(
            clientId: _getWebClientId(),
            scopes: ['email', 'profile'],
          ),
        );
      } else if (Platform.isAndroid) {
        // Android configuration - uses google-services.json
        _googleSignIn = GoogleSignIn(
          params: GoogleSignInParams(
            scopes: ['email', 'profile'],
          ),
        );
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop platforms use web-based OAuth
        _googleSignIn = GoogleSignIn(
          params: GoogleSignInParams(
            clientId: _getWebClientId(),
            scopes: ['email', 'profile'],
          ),
        );
      } else if (Platform.isIOS) {
        // iOS placeholder - will be implemented later
        AppLogger.auth('iOS Google Sign-In not yet implemented');
        return;
      }

      AppLogger.auth(
        'Google Sign-In initialized for ${PlatformAuthConfig.getCurrentPlatformName()}',
      );
    } catch (e) {
      AppLogger.error('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Get web client ID based on current flavor
  String _getWebClientId() {
    return FlavorConfig.instance.googleWebClientId;
  }

  /// Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      _initializeGoogleSignIn();

      // Check if platform is supported
      if (!PlatformAuthConfig.isGoogleSignInSupported()) {
        throw UnsupportedError(
          PlatformAuthConfig.getPlatformErrorMessage('platform_not_supported'),
        );
      }

      if (_googleSignIn == null) {
        throw Exception('Google Sign-In not properly initialized');
      }

      AppLogger.auth('Starting Google Sign-In flow');

      // Trigger the authentication flow
      final GoogleSignInCredentials? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        AppLogger.auth('User cancelled Google Sign-In');
        return null;
      }

      AppLogger.auth(
        'Google Sign-In successful for: ${googleUser.scopes.first}',
      );

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleUser.accessToken,
        idToken: googleUser.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Firebase authentication failed');
      }

      final appUser = AppUser.fromFirebaseUser(userCredential.user!);
      AppLogger.auth(
        'Firebase authentication successful for: ${appUser.email}',
      );

      return appUser;
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase Auth error during Google Sign-In: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      AppLogger.error('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      AppLogger.auth('Starting sign out process');

      // Sign out from Google if initialized
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
        AppLogger.auth('Google Sign-In sign out successful');
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();
      AppLogger.auth('Firebase sign out successful');
    } catch (e) {
      AppLogger.error('Error during sign out: $e');
      rethrow;
    }
  }

  /// Get current Firebase user
  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  /// Get current app user
  AppUser? getCurrentUser() {
    final firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser == null) return null;
    return AppUser.fromFirebaseUser(firebaseUser);
  }

  /// Check if user is currently signed in
  bool isUserSignedIn() {
    return getCurrentFirebaseUser() != null;
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream of app user changes
  Stream<AppUser?> get userChanges {
    return authStateChanges.map((user) {
      if (user == null) return null;
      return AppUser.fromFirebaseUser(user);
    });
  }

  /// Reload current user data
  Future<void> reloadUser() async {
    final user = getCurrentFirebaseUser();
    if (user != null) {
      await user.reload();
      AppLogger.auth('User data reloaded');
    }
  }

  /// Check if Google Sign-In is available on current platform
  bool isGoogleSignInAvailable() {
    return PlatformAuthConfig.isGoogleSignInSupported();
  }

  /// Get platform-specific error message
  String getPlatformErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'An account already exists with a different sign-in method.';
        case 'invalid-credential':
          return 'The credential is invalid or has expired.';
        case 'operation-not-allowed':
          return 'Google Sign-In is not enabled for this project.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No user found with this credential.';
        case 'wrong-password':
          return 'Invalid password.';
        case 'network-request-failed':
          return PlatformAuthConfig.getPlatformErrorMessage('network_error');
        default:
          return 'Authentication failed. Please try again.';
      }
    }

    if (error is UnsupportedError) {
      return error.message ??
          PlatformAuthConfig.getPlatformErrorMessage('platform_not_supported');
    }

    // Use platform-specific error messages
    return PlatformAuthConfig.getPlatformErrorMessage('unknown_error');
  }
}
