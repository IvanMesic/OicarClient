import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final baseUrlProvider =
    Provider<String>((ref) => 'http://138.68.77.85:5000/api');
final authServiceProvider = Provider<AuthService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return AuthService(baseUrl);
});
