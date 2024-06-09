import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/DioClient.dart';
import '../model/game_fill_blank_model.dart';

class LanguageService {
  final Dio dio = DioClient().dio;

  Future<List<LanguageDTO>> fetchLanguages() async {
    try {
      Response response = await dio.get('/lang');
      List<dynamic> data = response.data;
      return data.map((json) => LanguageDTO.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }
}

final languageServiceProvider = Provider<LanguageService>((ref) {
  return LanguageService();
});

final selectedLanguageProvider = StateProvider<LanguageDTO?>((ref) => null);

final languageListProvider = FutureProvider<List<LanguageDTO>>((ref) async {
  return ref.read(languageServiceProvider).fetchLanguages();
});

final languagesProvider = FutureProvider<List<LanguageDTO>>((ref) async {
  final languageService = ref.read(languageServiceProvider);
  return languageService.fetchLanguages();
});
