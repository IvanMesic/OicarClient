import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/model/game_fill_blank_model.dart';
import '../lib/services/game_service.dart';
import 'game_service_test.mocks.dart'; // Import generated mocks

@GenerateMocks([Dio])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late MockDio mockDio;
  late GameService gameService;

  setUp(() async {
    mockDio = MockDio();

    // Setting up SharedPreferences mock values
    SharedPreferences.setMockInitialValues({
      'languageId': 1,
    });

    // Initialize the GameService
    gameService = GameService();

    // Override dio in GameService
    gameService.dio = mockDio;
  });

  group('GameService', () {
    test('fetchGamePrompt returns GameFillBlankDTO on success', () async {
      const languageId = 1;
      const responseJson = {
        'id': 1,
        'language': null,
        'contextImage': null,
        'sentence': 'Test sentence',
      };

      when(mockDio.get('/game/fill-blank/$languageId')).thenAnswer((_) async =>
          Response(
              data: responseJson,
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      final result = await gameService.fetchGamePrompt();
      expect(result, isA<GameFillBlankDTO>());
      expect(result.id, 1);
      expect(result.sentence, 'Test sentence');
    });

    test('fetchGamePrompt throws error on failure', () async {
      const languageId = 1;

      when(mockDio.get('/game/fill-blank/$languageId')).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
      ));

      expect(gameService.fetchGamePrompt(), throwsException);
    });

    test('postGameResponse returns Response on success', () async {
      const sentence = 'Test sentence';
      const responseJson = {
        'status': 'ok',
      };

      when(mockDio.post(
        '/game/fill-blank/',
        data: {'sentence': sentence},
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: responseJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final response = await gameService.postGameResponse(sentence);
      expect(response.statusCode, 200);
    });

    test('postGameResponse throws error on failure', () async {
      const sentence = 'Test sentence';

      when(mockDio.post(
        '/game/fill-blank/',
        data: {'sentence': sentence},
        options: anyNamed('options'),
      )).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
      ));

      expect(gameService.postGameResponse(sentence), throwsException);
    });

    // Add similar tests for deleteCurrentFillBlankGame, fetchPickSentenceGame, postPickSentenceResponse, deleteCurrentPickSentenceGame, fetchFlashCardGame, postFlashCardResponse, and deleteCurrentFlashCardGame.
  });
}
