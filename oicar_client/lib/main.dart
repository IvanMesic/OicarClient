import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/login.dart';
import 'package:oicar_client/view/main_screen.dart';
import 'package:oicar_client/view/register.dart'; // Assuming MainMenuScreen is in this path

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example authentication status check - replace with your actual authentication check
    bool isAuthenticated =
        false; // This should be dynamically determined based on user status

    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Decide the initial route based on the authentication status
      home: isAuthenticated
          ? const MainMenuScreen()
          : const MyHomePage(title: 'Welcome to Flutter App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _navigateToRegister(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToRegister(context),
              child: const Text('Go to Register'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToLogin(context),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
