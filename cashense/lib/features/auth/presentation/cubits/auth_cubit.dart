/*

 Cubits are responsible for state management

*/

import 'package:cashense/features/auth/domain/entities/app_user.dart';
import 'package:cashense/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashense/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit(this.authRepository) : super(AuthInitial());

  // Get Current User
  AppUser? get currentUser => _currentUser;

  // Check if the user is authenticated
  void checkAuthStatus() async {
    emit(AuthLoading());

    final AppUser? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // Login with Email + Password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepository.loginWithEmailAndPassword(
        email,
        password,
      );

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // Register with Name + Email + Passord
  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      emit(AuthLoading());
      final user = await authRepository.registerWithEmailAndPassword(
        name,
        email,
        password,
      );

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // Logout
  Future<void> logout() async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(Unauthenticated());
  }

  // Forgot Password
  Future<String> forgotPassword(String email) async {
    try {
      final message = await authRepository.sendPasswordResetEmail(email);
      return message;
    } catch (e) {
      return e.toString();
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      emit(AuthLoading());
      await authRepository.deleteAccount();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }
}
