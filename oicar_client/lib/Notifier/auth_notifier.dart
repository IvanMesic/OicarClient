import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/basic_providers.dart';
import '../services/auth_service.dart';

// State to manage authentication
enum AuthStatus { initial, loading, success, error }

// Auth state model
class AuthState {
  final AuthStatus status;
  final String? error;
  final Map<String, dynamic>? userData;

  AuthState({this.status = AuthStatus.initial, this.error, this.userData});

  AuthState copyWith(
      {AuthStatus? status, String? error, Map<String, dynamic>? userData}) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      userData: userData ?? this.userData,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(AuthState());

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await authService.register(username, email, password);
      if (response.containsKey('token')) {
        state = state.copyWith(status: AuthStatus.success);
        // Proceed with login success logic, such as storing the token and navigating to the home screen.
      } else {
        state = state.copyWith(
            status: AuthStatus.error, error: 'Registration failed');
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await authService.login(username, password);
      if (response.containsKey('token')) {
        await authService.saveToken(response['token']);
        state = state.copyWith(status: AuthStatus.success);
      } else {
        state = state.copyWith(status: AuthStatus.error, error: 'Login failed');
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> getUserData() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final userData = await authService.getUserData();

      state = state.copyWith(status: AuthStatus.success, userData: userData);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
