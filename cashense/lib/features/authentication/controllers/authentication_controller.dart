import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cashense/features/authentication/models/app_user.dart';
import 'package:cashense/data/services/authentication_service.dart';
import 'package:cashense/utils/logging/logger.dart';

/// Authentication controller managing authentication state and business logic using GetX
class AuthenticationController extends GetxController {
  late final AuthenticationService _authService;

  // Reactive state variables
  final RxBool _isLoading = false.obs;
  final Rx<AppUser?> _user = Rx<AppUser?>(null);
  final RxBool _isAuthenticated = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters for reactive state
  bool get isLoading => _isLoading.value;
  AppUser? get user => _user.value;
  bool get isAuthenticated => _isAuthenticated.value;
  String get errorMessage => _errorMessage.value;

  // Observable getters for UI binding
  RxBool get isLoadingObs => _isLoading;
  Rx<AppUser?> get userObs => _user;
  RxBool get isAuthenticatedObs => _isAuthenticated;
  RxString get errorMessageObs => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    // Inject AuthenticationService dependency
    _authService = Get.find<AuthenticationService>();
    _initializeAuthState();
  }

  /// Initialize authentication state and listen to auth changes
  void _initializeAuthState() {
    try {
      AppLogger.auth('Initializing authentication state');
      
      // Check current authentication state
      checkAuthState();
      
      // Listen to authentication state changes
      _authService.userChanges.listen(
        (AppUser? user) {
          _updateUserState(user);
        },
        onError: (error) {
          AppLogger.error('Auth state change error: $error');
          _handleError(error);
        },
      );
      
      AppLogger.auth('Authentication state initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize authentication state: $e');
      _handleError(e);
    }
  }

  /// Update user state when authentication changes
  void _updateUserState(AppUser? user) {
    _user.value = user;
    _isAuthenticated.value = user != null;
    
    if (user != null) {
      AppLogger.auth('User authenticated: ${user.email}');
      _clearError();
    } else {
      AppLogger.auth('User signed out');
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();
      
      AppLogger.auth('Starting Google Sign-In process');
      
      final AppUser? user = await _authService.signInWithGoogle();
      
      if (user != null) {
        _updateUserState(user);
        AppLogger.auth('Google Sign-In successful for: ${user.email}');
        return true;
      } else {
        // User cancelled the sign-in
        AppLogger.auth('Google Sign-In cancelled by user');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth error during sign-in: ${e.code} - ${e.message}');
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      AppLogger.error('Error during Google Sign-In: $e');
      _handleError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();
      
      AppLogger.auth('Starting sign out process');
      
      await _authService.signOut();
      
      // Clear user state
      _updateUserState(null);
      
      AppLogger.auth('Sign out successful');
    } catch (e) {
      AppLogger.error('Error during sign out: $e');
      _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Check current authentication state
  void checkAuthState() {
    try {
      AppLogger.auth('Checking authentication state');
      
      final AppUser? currentUser = _authService.getCurrentUser();
      _updateUserState(currentUser);
      
      if (currentUser != null) {
        AppLogger.auth('User is authenticated: ${currentUser.email}');
      } else {
        AppLogger.auth('No authenticated user found');
      }
    } catch (e) {
      AppLogger.error('Error checking authentication state: $e');
      _handleError(e);
    }
  }

  /// Get current user information
  AppUser? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  /// Reload current user data
  Future<void> reloadUser() async {
    try {
      AppLogger.auth('Reloading user data');
      await _authService.reloadUser();
      
      // Update user state with fresh data
      final AppUser? refreshedUser = _authService.getCurrentUser();
      _updateUserState(refreshedUser);
      
      AppLogger.auth('User data reloaded successfully');
    } catch (e) {
      AppLogger.error('Error reloading user data: $e');
      _handleError(e);
    }
  }

  /// Check if Google Sign-In is available on current platform
  bool isGoogleSignInAvailable() {
    return _authService.isGoogleSignInAvailable();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Handle general errors
  void _handleError(dynamic error) {
    final errorMessage = _authService.getPlatformErrorMessage(error);
    _errorMessage.value = errorMessage;
    AppLogger.error('Authentication error: $errorMessage');
  }

  /// Handle Firebase Auth specific errors
  void _handleFirebaseAuthError(FirebaseAuthException error) {
    String userFriendlyMessage;
    
    switch (error.code) {
      case 'account-exists-with-different-credential':
        userFriendlyMessage = 'An account already exists with a different sign-in method.';
        break;
      case 'invalid-credential':
        userFriendlyMessage = 'The credential is invalid or has expired.';
        break;
      case 'operation-not-allowed':
        userFriendlyMessage = 'Google Sign-In is not enabled for this project.';
        break;
      case 'user-disabled':
        userFriendlyMessage = 'This user account has been disabled.';
        break;
      case 'user-not-found':
        userFriendlyMessage = 'No user found with this credential.';
        break;
      case 'network-request-failed':
        userFriendlyMessage = 'Please check your internet connection and try again.';
        break;
      case 'too-many-requests':
        userFriendlyMessage = 'Too many attempts. Please try again later.';
        break;
      default:
        userFriendlyMessage = 'Authentication failed. Please try again.';
    }
    
    _errorMessage.value = userFriendlyMessage;
    AppLogger.error('Firebase Auth error: ${error.code} - ${error.message}');
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  /// Internal method to clear error
  void _clearError() {
    _errorMessage.value = '';
  }

  /// Check if there's an active error
  bool get hasError => _errorMessage.value.isNotEmpty;

  @override
  void onClose() {
    AppLogger.auth('Authentication controller disposed');
    super.onClose();
  }
}