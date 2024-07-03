import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oicar_client/main.dart' as app;
import 'package:oicar_client/provider/auth_provider.dart';

import 'mock/mock_auth_service.dart';
import 'robots/login_robot.dart';
import 'robots/register_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Tests', () {
    late LoginRobot loginRobot;
    late RegisterRobot registerRobot;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    ProviderContainer overrideProviders(MockAuthService mockAuthService) {
      return ProviderContainer(
        overrides: [
          authServiceProv.overrideWithValue(mockAuthService),
        ],
      );
    }

    testWidgets('Successful Login', (WidgetTester tester) async {
      when(mockAuthService.login('correctUsername', 'correctPassword'))
          .thenAnswer((_) async => {'token': 'fake_token'});

      final container = overrideProviders(mockAuthService);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const app.MyApp(),
        ),
      );

      // Navigate to the login screen
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      loginRobot = LoginRobot(tester);

      // Perform login actions
      await loginRobot.enterUsername('correctUsername');
      await loginRobot.enterPassword('correctPassword');
      await loginRobot.tapLoginButton();
      await loginRobot.verifyNavigationToHome();
    });

    testWidgets('Failed Login', (WidgetTester tester) async {
      when(mockAuthService.login('wrongUsername', 'wrongPassword'))
          .thenThrow(Exception('Invalid credentials'));

      final container = overrideProviders(mockAuthService);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const app.MyApp(),
        ),
      );

      // Navigate to the login screen
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      // Perform login actions
      await loginRobot.enterUsername('wrongUsername');
      await loginRobot.enterPassword('wrongPassword');
      await loginRobot.tapLoginButton();
      await loginRobot.verifyError();
    });

    testWidgets('Successful Registration', (WidgetTester tester) async {
      when(mockAuthService.register(
              'correctUsername', 'correctEmail', 'correctPassword'))
          .thenAnswer((_) async => {'token': 'fake_token'});

      final container = overrideProviders(mockAuthService);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const app.MyApp(),
        ),
      );

      // Navigate to the register screen
      await tester.tap(find.byKey(Key('register_button_main')));
      await tester.pumpAndSettle();
      registerRobot = RegisterRobot(tester);
      // Perform registration actions
      await registerRobot.enterUsername('correctUsername');
      await registerRobot.enterEmail('correctEmail');
      await registerRobot.enterPassword('correctPassword');
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyNavigationToLogin();
    });

    testWidgets('Failed Registration', (WidgetTester tester) async {
      when(mockAuthService.register(
              'wrongUsername', 'wrongEmail', 'wrongPassword'))
          .thenThrow(Exception('Invalid registration details'));

      final container = overrideProviders(mockAuthService);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const app.MyApp(),
        ),
      );

      // Navigate to the register screen
      await tester.tap(find.byKey(Key('register_button_main')));
      await tester.pumpAndSettle();
      registerRobot = RegisterRobot(tester);
      // Perform registration actions
      await registerRobot.enterUsername('wrongUsername');
      await registerRobot.enterEmail('wrongEmail');
      await registerRobot.enterPassword('wrongPassword');
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyError();
    });
  });
}
