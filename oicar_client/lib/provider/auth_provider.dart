import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Notifier/auth_notifier.dart';
import '../services/auth_service.dart';

final storageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final authServiceProv = Provider<AuthService>((ref) {
  final storage = ref.watch(storageProvider);
  return AuthService(storage);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProv);
  return AuthNotifier(authService);
});
