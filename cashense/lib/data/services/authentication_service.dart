import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart' as gsi_dartio;
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
  gsi.GoogleSignIn? _googleSignIn;

  /// Initialize Google Sign-In with platform-specific configuration
  Future<void> _initializeGoogleSignIn() async {
    if (_googleSignIn != null) return;

    try {
      PlatformAuthConfig.logPlatformConfiguration();

      if (!PlatformAuthConfig.validatePlatformConfiguration()) {
        AppLogger.error('Platform configuration validation failed');
        return;
      }

      if (!PlatformAuthConfig.isGoogleSignInSupported()) {
        AppLogger.auth('Google Sign-In not supported on current platform');
        return;
      }

      // Skip GoogleSignIn setup on web; we'll use Firebase popup directly
      if (GetPlatform.isWeb) {
        AppLogger.auth('Web platform detected - using Firebase popup flow');
        return;
      }

      // Desktop registration for pure-Dart implementation
      if (GetPlatform.isWindows || GetPlatform.isLinux || GetPlatform.isMacOS) {
        final desktopClientId = GetPlatform.isMacOS
            ? FlavorConfig.instance.googleIOSClientId
            : FlavorConfig.instance.googleWebClientId;
        await gsi_dartio.GoogleSignInDart.register(clientId: desktopClientId);
      }

      if (GetPlatform.isAndroid) {
        _googleSignIn = gsi.GoogleSignIn(
          scopes: const ['email', 'profile'],
        );
      } else if (GetPlatform.isIOS || GetPlatform.isMacOS) {
        _googleSignIn = gsi.GoogleSignIn(
          clientId: FlavorConfig.instance.googleIOSClientId,
          scopes: const ['email', 'profile'],
        );
      } else if (GetPlatform.isWindows || GetPlatform.isLinux) {
        _googleSignIn = gsi.GoogleSignIn(
          scopes: const ['email', 'profile'],
        );
      }

      AppLogger.auth(
        'Google Sign-In initialized for ${PlatformAuthConfig.getCurrentPlatformName()}',
      );
    } catch (e) {
      AppLogger.error('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<AppUser?> signInWithGoogle() async {
    try {
      AppLogger.auth(
        'Starting Google Sign-In flow for ${PlatformAuthConfig.getCurrentPlatformName()}',
      );

      if (!PlatformAuthConfig.isGoogleSignInSupported()) {
        throw UnsupportedError(
          PlatformAuthConfig.getPlatformErrorMessage('platform_not_supported'),
        );
      }

      return await _signInWithGoogleSignIn();
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

  /// Sign in with Google using official plugin (mobile/desktop) or Firebase popup (web)
  Future<AppUser?> _signInWithGoogleSignIn() async {
    try {
      // Web: use popup/redirect provider flow
      if (GetPlatform.isWeb) {
        AppLogger.auth('Using Firebase Auth popup for Web Google Sign-In');
        final provider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(provider);
        if (userCredential.user == null) {
          throw Exception('Firebase authentication failed');
        }
        final appUser = AppUser.fromFirebaseUser(userCredential.user!);
        AppLogger.auth(
          'Firebase authentication successful for: ${appUser.email}',
        );
        return appUser;
      }

      await _initializeGoogleSignIn();

      if (_googleSignIn == null) {
        throw Exception('Google Sign-In not properly initialized');
      }

      AppLogger.auth('Using Google Sign-In');

      final gsi.GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        AppLogger.auth('User cancelled Google Sign-In');
        return null;
      }

      final gsi.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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
    } catch (e) {
      AppLogger.error('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      AppLogger.auth('Starting sign out process');

      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
        AppLogger.auth('Google Sign-In sign out successful');
      }

      await _firebaseAuth.signOut();
      AppLogger.auth('Firebase sign out successful');
    } catch (e) {
      AppLogger.error('Error during sign out: $e');
      rethrow;
    }
  }

  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  AppUser? getCurrentUser() {
    final firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser == null) return null;
    return AppUser.fromFirebaseUser(firebaseUser);
  }

  bool isUserSignedIn() {
    return getCurrentFirebaseUser() != null;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<AppUser?> get userChanges {
    return authStateChanges.map((user) {
      if (user == null) return null;
      return AppUser.fromFirebaseUser(user);
    });
  }

  Future<void> reloadUser() async {
    final user = getCurrentFirebaseUser();
    if (user != null) {
      await user.reload();
      AppLogger.auth('User data reloaded');
    }
  }

  bool isGoogleSignInAvailable() {
    return PlatformAuthConfig.isGoogleSignInSupported();
  }

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

    return PlatformAuthConfig.getPlatformErrorMessage('unknown_error');
  }
}
