import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/lading_page.dart';

import '../notifier/auth_notifier.dart'; // Update with your actual file path

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        // Navigate to the ProfileScreen when login is successful
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              const ProfileScreen(), // Replace with your profile screen widget
        ));
      } else if (next.status == AuthStatus.error) {
        // Show an error message if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(authNotifierProvider.notifier).login(
                    usernameController.text,
                    passwordController.text,
                  ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final authState = ref.watch(authNotifierProvider);
                if (authState.status == AuthStatus.loading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox.shrink(); // placeholder for empty space
              },
            ),
          ],
        ),
      ),
    );
  }
}
