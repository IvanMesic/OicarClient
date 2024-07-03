import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:oicar_client/model/game_fill_blank_model.dart';
import 'package:oicar_client/model/game_flash_card_model.dart';
import 'package:oicar_client/services/game_service.dart';

class MockGameService extends Mock implements GameService {
  @override
  Future<GameFillBlankDTO> fetchGamePrompt() {
    return super.noSuchMethod(
      Invocation.method(#fetchGamePrompt, []),
      returnValue: Future.value(
        GameFillBlankDTO(
          id: 1,
          sentence: 'Hello _ World',
          language: LanguageDTO(id: 1, name: 'English'),
          contextImage: null,
        ),
      ),
      returnValueForMissingStub: Future.value(
        GameFillBlankDTO(
          id: 1,
          sentence: 'Hello _ World',
          language: LanguageDTO(id: 1, name: 'English'),
          contextImage: null,
        ),
      ),
    );
  }

  @override
  Future<Response> postGameResponse(String sentence) {
    return super.noSuchMethod(
      Invocation.method(#postGameResponse, [sentence]),
      returnValue: Future.value(
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
      returnValueForMissingStub: Future.value(
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );
  }

  @override
  Future<GameFlashCardDTO> fetchFlashCardGame() {
    return super.noSuchMethod(
      Invocation.method(#fetchFlashCardGame, []),
      returnValue: Future.value(
        GameFlashCardDTO(
          id: 1,
          text: 'What is Flutter?',
          answer: 'A UI toolkit',
          language: LanguageDTO(id: 1, name: 'English'),
          contextImage: ContextImageDTO(imagePath: 'path/to/image', id: 1),
        ),
      ),
      returnValueForMissingStub: Future.value(
        GameFlashCardDTO(
          id: 1,
          text: 'What is Flutter?',
          answer: 'A UI toolkit',
          language: LanguageDTO(id: 1, name: 'English'),
          contextImage: ContextImageDTO(imagePath: 'path/to/image', id: 1),
        ),
      ),
    );
  }

  @override
  Future<Response> postFlashCardResponse(String response) {
    return super.noSuchMethod(
      Invocation.method(#postFlashCardResponse, [response]),
      returnValue: Future.value(
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
      returnValueForMissingStub: Future.value(
        Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );
  }
}
