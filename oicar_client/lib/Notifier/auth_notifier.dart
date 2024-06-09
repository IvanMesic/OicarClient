import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  final Map<String, dynamic>? userData;

  const AuthState(
      {this.status = AuthStatus.initial, this.error, this.userData});

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    Map<String, dynamic>? userData,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      userData: userData ?? this.userData,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(const AuthState());

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await authService.register(username, email, password);
      if (response['token'] != null) {
        state = state.copyWith(status: AuthStatus.success);
      } else {
        state = state.copyWith(
            status: AuthStatus.error,
            error: response['error'] ?? 'Unknown registration error');
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await authService.login(username, password);
      if (response['token'] != null) {
        await authService.saveToken(response['token']);
        state = state.copyWith(status: AuthStatus.success);
      } else {
        state = state.copyWith(
            status: AuthStatus.error,
            error: response['error'] ?? 'Unknown login error');
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
  final authService = ref.watch(authServiceProv);
  return AuthNotifier(authService);
});
