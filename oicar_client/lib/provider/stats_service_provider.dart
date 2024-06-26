import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/language_stats_model.dart';
import '../services/stats_service.dart';

final statsServiceProvider = Provider<StatsService>((ref) {
  return StatsService();
});

final statsProvider =
    FutureProvider.family.autoDispose<List<LanguageStat>, int>((ref, langId) {
  final statsService = ref.read(statsServiceProvider);
  return statsService.fetchStats(langId);
});
