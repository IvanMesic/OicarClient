import 'package:mockito/mockito.dart';
import 'package:oicar_client/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  @override
  Future<Map<String, dynamic>> login(String username, String password) {
    return super.noSuchMethod(
      Invocation.method(#login, [username, password]),
      returnValue: Future.value(<String, dynamic>{}),
      returnValueForMissingStub: Future.value(<String, dynamic>{}),
    );
  }

  @override
  Future<Map<String, dynamic>> register(
      String username, String email, String password) {
    return super.noSuchMethod(
      Invocation.method(#register, [username, email, password]),
      returnValue: Future.value(<String, dynamic>{}),
      returnValueForMissingStub: Future.value(<String, dynamic>{}),
    );
  }

  @override
  Future<void> saveToken(String token) {
    return super.noSuchMethod(
      Invocation.method(#saveToken, [token]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<void> saveUsername(String username) {
    return super.noSuchMethod(
      Invocation.method(#saveUsername, [username]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}
