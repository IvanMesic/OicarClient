import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataFuture = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userDataFuture.when(
        data: (data) => Center(child: _buildUserInfo(context, data)),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, Map<String, dynamic> userData) {
    final username = userData['username'] ?? 'Unknown';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Username: $username',
            style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }
}

final userDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authService = ref.watch(authServiceProv);
  return await authService.getUserData();
});
