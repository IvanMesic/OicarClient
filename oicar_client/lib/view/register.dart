import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Notifier/auth_notifier.dart';

class RegisterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final authNotifier = ref.read(authNotifierProvider.notifier);
                await authNotifier.register(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Register'),
            ),
            Consumer(
              builder: (context, ref, child) {
                final authState = ref.watch(authNotifierProvider);
                if (authState.status == AuthStatus.loading) {
                  return CircularProgressIndicator();
                } else if (authState.status == AuthStatus.error) {
                  return Text(authState.error ?? 'Unknown error');
                }
                return Container(); // Empty container for initial and success states
              },
            )
          ],
        ),
      ),
    );
  }
}
