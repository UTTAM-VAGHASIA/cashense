import 'package:cashense/features/auth/domain/entities/app_user.dart';
import 'package:cashense/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepository {
  // Access to firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential uc = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create User
      AppUser user = AppUser(
        uid: uc.user!.uid,
        email: email,
        photoUrl: uc.user!.photoURL ?? '',
      );

      return user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential uc = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create User
      AppUser user = AppUser(
        uid: uc.user!.uid,
        email: email,
        photoUrl: uc.user!.photoURL ?? '',
      );

      return user;
    } catch (e) {
      throw Exception('Registration Failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) throw Exception('No User Logged in...');

      await user.delete();

      await logout();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return null;

    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent! Check your inbox.';
    } catch (e) {
      return 'Failed to send password reset email: $e';
    }
  }
}
