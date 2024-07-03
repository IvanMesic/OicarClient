import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class RegisterRobot {
  final WidgetTester tester;

  RegisterRobot(this.tester);

  Future<void> enterUsername(String username) async {
    final usernameField = find.byKey(Key('username_field'));
    await tester.enterText(usernameField, username);
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(Key('email_field'));
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(Key('password_field'));
    await tester.enterText(passwordField, password);
  }

  Future<void> tapRegisterButton() async {
    final registerButton = find.byKey(Key('register_button'));
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyNavigationToLogin() async {
    expect(find.byKey(Key('login_button')), findsOneWidget);
  }

  Future<void> verifyError() async {
    expect(find.byKey(Key('registration_error_snackbar')), findsOneWidget);
  }
}
