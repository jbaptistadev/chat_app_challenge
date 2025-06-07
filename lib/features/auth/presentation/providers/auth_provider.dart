import 'package:epale_app/features/auth/domain/entities/user.dart';
import 'package:epale_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:epale_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:epale_app/features/auth/infrastructure/repositories/auth_repository.impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = authRepository.checkAuthStatus();
      _setLoggedUser(user);
    } catch (error) {
      logout('Your session has expired. Please log in again.');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await authRepository.signIn(email, password);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Your session has expired. Please log in again.');
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      final user = await authRepository.signUp(email, password, username);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Your session has expired. Please log in again.');
    }
  }

  void _setLoggedUser(UserEntity user) {
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    try {
      await authRepository.signOut();
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage ?? '',
      );
    } catch (e) {
      throw CustomError('Logout failed: $e');
    }
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserEntity? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
