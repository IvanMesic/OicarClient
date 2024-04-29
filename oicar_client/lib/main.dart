import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oicar_client/view/login.dart'; // Make sure to import your actual LoginPage
import 'package:oicar_client/view/register.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // ... your theme data
          ),
      // The MyHomePage should probably be the initial route if it's the landing page of the app
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _navigateToRegister(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterPage(),
    ));
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          const LoginScreen(), // Assuming you have a LoginPage
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              child:
                  const Text('Go to Login'), // Button for navigating to Login
            ),
          ],
        ),
      ),
    );
  }
}
