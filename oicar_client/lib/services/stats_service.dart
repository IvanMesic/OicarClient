import 'package:dio/dio.dart';

import '../model/DioClient.dart';
import '../model/language_stats_model.dart';

class StatsService {
  final Dio dio = DioClient().dio;

  Future<List<LanguageStat>> fetchStats(int langId) async {
    try {
      final response = await dio.get('/stats/$langId');
      List<dynamic> data = response.data;
      return data.map((json) => LanguageStat.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }
}
