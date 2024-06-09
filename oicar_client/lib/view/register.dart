import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Notifier/auth_notifier.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(authNotifierProvider.notifier).register(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                  ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, _) {
                final authState = ref.watch(authNotifierProvider);
                if (authState.status == AuthStatus.loading) {
                  return const CircularProgressIndicator();
                } else if (authState.status == AuthStatus.error) {
                  return Text(authState.error ?? 'Unknown error');
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
