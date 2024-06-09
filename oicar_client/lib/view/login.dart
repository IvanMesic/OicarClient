import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/main_screen.dart';

import '../notifier/auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainMenuScreen(),
        ));
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(next.error ?? 'Login failed'),
              backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref
                    .read(authNotifierProvider.notifier)
                    .login(usernameController.text, passwordController.text),
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, _) {
                  final authState = ref.watch(authNotifierProvider);
                  if (authState.status == AuthStatus.loading) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
