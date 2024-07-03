import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oicar_client/main.dart' as app;
import 'package:oicar_client/model/game_fill_blank_model.dart';
import 'package:oicar_client/model/game_flash_card_model.dart';
import 'package:oicar_client/provider/auth_provider.dart';
import 'package:oicar_client/provider/game_providers.dart';
import 'package:oicar_client/services/preference_service.dart';
import 'package:oicar_client/view/flash_card_game_screen.dart';
import 'package:oicar_client/view/main_screen.dart';

import 'mock/mock_auth_service.dart';
import 'mock/mock_game_service.dart';
import 'mock/mock_preference_service.dart';
import 'robots/flash_card_robot.dart';
import 'robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Tests', () {
    late LoginRobot loginRobot;
    late FlashCardRobot flashCardRobot;
    late MockAuthService mockAuthService;
    late MockGameService mockGameService;
    late MockPreferencesService mockPreferencesService;

    setUp(() {
      mockAuthService = MockAuthService();
      mockGameService = MockGameService();
      mockPreferencesService = MockPreferencesService();
    });

    ProviderContainer overrideProviders(
        MockAuthService mockAuthService,
        MockGameService mockGameService,
        MockPreferencesService mockPreferencesService) {
      return ProviderContainer(
        overrides: [
          authServiceProv.overrideWithValue(mockAuthService),
          gameServiceProvider.overrideWithValue(mockGameService),
          preferencesServiceProvider.overrideWithValue(mockPreferencesService),
        ],
      );
    }

    testWidgets('Successful Flash Card Game', (WidgetTester tester) async {
      // Mock login response
      when(mockAuthService.login('correctUsername', 'correctPassword'))
          .thenAnswer((_) async => {'token': 'fake_token'});

      // Mock game prompt fetch response
      when(mockGameService.fetchFlashCardGame()).thenAnswer((_) async =>
          GameFlashCardDTO(
              id: 1,
              text: 'What is Flutter?',
              answer: 'A UI toolkit',
              language: LanguageDTO(id: 1, name: 'English'),
              contextImage:
                  ContextImageDTO(imagePath: 'path/to/image', id: 1)));

      // Mock game response submission
      when(mockGameService.postFlashCardResponse('A UI toolkit'))
          .thenAnswer((_) async => Response(
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final container = overrideProviders(
          mockAuthService, mockGameService, mockPreferencesService);

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

      // Verify we are on the MainMenuScreen
      expect(find.byType(MainMenuScreen), findsOneWidget);
      print('Navigated to MainMenuScreen');

      // Set the provider state to trigger navigation to FlashCardGameScreen
      container.read(currentFlashCardGameProvider.notifier).state =
          GameFlashCardDTO(
        id: 1,
        text: 'What is Flutter?',
        answer: 'A UI toolkit',
        language: LanguageDTO(id: 1, name: 'English'),
        contextImage: ContextImageDTO(imagePath: 'path/to/image', id: 1),
      );
      await tester.pumpAndSettle();

      // Verify navigation to FlashCardGameScreen
      expect(find.byType(FlashCardGameScreen), findsOneWidget);
      print('Navigated to FlashCardGameScreen');

      flashCardRobot = FlashCardRobot(tester);

      // Ensure response_field exists
      expect(find.byKey(const Key('response_field')), findsOneWidget);

      // Perform flash card game actions
      await flashCardRobot.enterResponse('A UI toolkit');

      // Unfocus the text field to dismiss the keyboard
      FocusScope.of(tester.element(find.byKey(const Key('response_field'))))
          .unfocus();
      await tester.pumpAndSettle();

      // Scroll to the submit button to ensure it's visible
      final submitButtonFinder = find.byKey(const Key('submit_button'));
      await tester.pumpAndSettle();

      // Ensure the button is in the center of the screen and visible
      final Offset center = tester.getCenter(submitButtonFinder);
      expect(center.dy,
          lessThanOrEqualTo(tester.binding.window.physicalSize.height));

      // Tap the submit button
      await flashCardRobot.tapSubmitButton();

      // Verify the correct answer is displayed
      await flashCardRobot.verifyCorrectAnswer();
    });

    testWidgets('Failed Flash Card Game', (WidgetTester tester) async {
      // Mock login response
      when(mockAuthService.login('correctUsername', 'correctPassword'))
          .thenAnswer((_) async => {'token': 'fake_token'});

      // Mock game prompt fetch response
      when(mockGameService.fetchFlashCardGame())
          .thenAnswer((_) async => GameFlashCardDTO(
                id: 1,
                text: 'What is Flutter?',
                answer: 'A UI toolkit',
                language: LanguageDTO(id: 1, name: 'English'),
                contextImage:
                    ContextImageDTO(imagePath: 'path/to/image', id: 1),
              ));

      // Mock game response submission failure
      when(mockGameService.postFlashCardResponse('A framework'))
          .thenAnswer((_) async => Response(
                statusCode: 406,
                requestOptions: RequestOptions(path: ''),
              ));

      final container = overrideProviders(
          mockAuthService, mockGameService, mockPreferencesService);

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

      // Verify we are on the MainMenuScreen
      expect(find.byType(MainMenuScreen), findsOneWidget);
      print('Navigated to MainMenuScreen');

      // Set the provider state to trigger navigation to FlashCardGameScreen
      container.read(currentFlashCardGameProvider.notifier).state =
          GameFlashCardDTO(
        id: 1,
        text: 'What is Flutter?',
        answer: 'A UI toolkit',
        language: LanguageDTO(id: 1, name: 'English'),
        contextImage: ContextImageDTO(imagePath: 'path/to/image', id: 1),
      );
      await tester.pumpAndSettle();

      // Verify navigation to FlashCardGameScreen
      expect(find.byType(FlashCardGameScreen), findsOneWidget);
      print('Navigated to FlashCardGameScreen');

      flashCardRobot = FlashCardRobot(tester);

      // Ensure response_field exists
      expect(find.byKey(const Key('response_field')), findsOneWidget);

      // Perform flash card game actions
      await flashCardRobot.enterResponse('A framework');

      // Unfocus the text field to dismiss the keyboard
      FocusScope.of(tester.element(find.byKey(const Key('response_field'))))
          .unfocus();
      await tester.pumpAndSettle();

      // Scroll to the submit button to ensure it's visible
      final submitButtonFinder = find.byKey(const Key('submit_button'));
      await tester.pumpAndSettle();

      // Ensure the button is in the center of the screen and visible
      final Offset center = tester.getCenter(submitButtonFinder);
      expect(center.dy,
          lessThanOrEqualTo(tester.binding.window.physicalSize.height));

      // Tap the submit button
      await flashCardRobot.tapSubmitButton();

      // Verify the incorrect answer is displayed
      await flashCardRobot.verifyIncorrectAnswer();
    });
  });
}
