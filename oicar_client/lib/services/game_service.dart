// game_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/DioClient.dart';
import '../model/game_fill_blank_model.dart';
import '../model/game_flash_card_model.dart';
import '../model/game_pick_sentence_model.dart';

class GameService {
  final Dio dio = DioClient().dio;

  Future<int?> _getSavedLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('languageId');
  }

  Future<GameFillBlankDTO> fetchGamePrompt() async {
    try {
      final int languageId = (await _getSavedLanguageId()) ?? 1;
      final response = await dio.get('/game/fill-blank/$languageId');
      return GameFillBlankDTO.fromJson(response.data);
    } catch (e) {
      print(
          'You are already playing a game. Please end it before starting a new one!');
      rethrow;
    }
  }

  Future<Response> postGameResponse(String sentence) async {
    try {
      return await dio.post('/game/fill-blank/',
          data: {'sentence': sentence},
          options: Options(validateStatus: (status) => status! < 500));
    } catch (e) {
      print('Error posting game response: $e');
      rethrow;
    }
  }

  Future<void> deleteCurrentFillBlankGame() async {
    try {
      Response response = await dio.delete('/game/fill-blank/');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error deleting fill blank game: $e');
      rethrow;
    }
  }

  Future<GamePickSentenceDTO> fetchPickSentenceGame() async {
    try {
      final int languageId = (await _getSavedLanguageId()) ?? 1;
      final response = await dio.get('/game/pick-sentence/$languageId');
      return GamePickSentenceDTO.fromJson(response.data);
    } catch (e) {
      print(
          'You are already playing a game. Please end it before starting a new one!');
      rethrow;
    }
  }

  Future<Response> postPickSentenceResponse(String sentence) async {
    try {
      return await dio.post('/game/pick-sentence/',
          data: {'sentence': sentence},
          options: Options(validateStatus: (status) => status! < 500));
    } catch (e) {
      print('Error posting pick sentence game response: $e');
      rethrow;
    }
  }

  Future<void> deleteCurrentPickSentenceGame() async {
    try {
      Response response = await dio.delete('/game/pick-sentence/');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error deleting pick sentence game: $e');
      rethrow;
    }
  }

  Future<void> deleteCurrentFlashCardGame() async {
    try {
      Response response = await dio.delete('/game/flash-card/');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error deleting flash card game: $e');
      rethrow;
    }
  }

  Future<GameFlashCardDTO> fetchFlashCardGame() async {
    try {
      final int languageId = (await _getSavedLanguageId()) ?? 1;
      final response = await dio.get('/game/flash-card/$languageId');
      return GameFlashCardDTO.fromJson(response.data);
    } catch (e) {
      print('Error fetching flash card game: $e');
      rethrow;
    }
  }

  Future<Response> postFlashCardResponse(String response) async {
    try {
      return await dio.post('/game/flash-card/',
          data: {'sentence': response},
          options: Options(validateStatus: (status) => status! < 500));
    } catch (e) {
      print('Error posting flash card game response: $e');
      rethrow;
    }
  }
}
