import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  late final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://138.68.77.85:5000/api',
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 11000),
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(HeaderInterceptor(storage));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}

class HeaderInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  HeaderInterceptor(this.storage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await storage.read(key: 'jwt_token');

    options.headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
