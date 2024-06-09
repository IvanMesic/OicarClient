import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _languageKey = 'languageId';

  Future<void> saveLanguageId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_languageKey, id);
  }

  Future<int?> loadLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_languageKey);
  }
}

final languageIdProvider = StateNotifierProvider<LanguageNotifier, int?>((ref) {
  return LanguageNotifier(ref.read(preferencesServiceProvider));
});

class LanguageNotifier extends StateNotifier<int?> {
  final PreferencesService _preferencesService;

  LanguageNotifier(this._preferencesService) : super(null) {
    _loadSavedLanguage();
  }

  void selectLanguage(int id) async {
    state = id;
    await _preferencesService.saveLanguageId(id);
  }

  Future<void> _loadSavedLanguage() async {
    final savedId = await _preferencesService.loadLanguageId();
    if (savedId != null) {
      state = savedId;
    }
  }
}

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
