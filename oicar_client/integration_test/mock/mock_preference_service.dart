import 'package:mockito/mockito.dart';
import 'package:oicar_client/services/preference_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {
  @override
  Future<int?> loadLanguageId() {
    return Future.value(1);
  }

  @override
  Future<void> saveLanguageId(int id) {
    return Future.value();
  }
}
