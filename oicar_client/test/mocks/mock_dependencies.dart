import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:oicar_client/model/DioClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockDioClient extends Mock implements DioClient {
  final Dio mockDio;
  MockDioClient(this.mockDio);

  @override
  Dio get dio => mockDio;
}
