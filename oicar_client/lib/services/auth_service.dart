import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oicar_client/model/DioClient.dart';

class AuthService {
  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage;

  AuthService(this.storage);

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: jsonEncode(
            {'Username': username, 'Email': email, 'Password': password}),
      );
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data;
      } else {
        throw Exception('Registration failed. Please try again later.');
      }
    } on DioException catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed due to network issues.');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: jsonEncode({'Username': username, 'Password': password}),
      );

      print(response.headers);
      print(response.statusCode);
      print(response.data);
      print(response.statusMessage);

      if (response.statusCode == 200) {
        await saveToken(response.data['token']);
        return response.data;
      } else {
        throw Exception(
            'Login failed. Please check your credentials and try again.');
      }
    } on DioException catch (e) {
      print('Login error: $e');
      throw Exception('Login failed due to network issues.');
    }
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<Map<String, dynamic>> getUserData() async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No token found. User is not logged in.');
    }

    try {
      final response = await dio.get(
        '/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please log in again.');
      } else {
        throw Exception(
            'Failed to get user data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
