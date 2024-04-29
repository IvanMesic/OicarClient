import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Email': email,
          'Password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print(
          'Response Body: "${response.body}"'); // Ensure that body is logged with quotes

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return json.decode(response.body);
      } else if (response.body.isEmpty) {
        throw Exception('Received empty response body with status 200');
      } else {
        throw Exception(
            'Failed to register. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<Map<String, dynamic>> getUserData() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No token found. User is not logged in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    } else {
      throw Exception(
          'Failed to get user data with status code: ${response.statusCode}');
    }
  }
}
