import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oicar_client/view/main_screen.dart'; // Ensure this is the correct import

class LoginRobot {
  final WidgetTester tester;

  LoginRobot(this.tester);

  Future<void> enterUsername(String username) async {
    final usernameField = find.byKey(const Key('username_field'));
    await tester.enterText(usernameField, username);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(const Key('password_field'));
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(const Key('login_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyError() async {
    final errorSnackbar = find.byKey(const Key('login_error_snackbar'));
    expect(errorSnackbar, findsOneWidget);
  }

  Future<void> verifyNavigationToHome() async {
    final mainMenuScreen =
        find.byType(MainMenuScreen); // Ensure you import MainMenuScreen
    expect(mainMenuScreen, findsOneWidget);
  }
}
