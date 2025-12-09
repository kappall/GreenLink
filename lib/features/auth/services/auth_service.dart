import 'dart:convert';

import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final payload = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    return _handleAuthResponse(response, 'login');
  }

  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final payload = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    return _handleAuthResponse(response, 'registrazione');
  }

  AuthResult _handleAuthResponse(http.Response response, String action) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = _safeDecode(response.body);
      final token = data['token'] as String?;
      UserModel? user;

      final userJson = data['user'];
      if (userJson is Map<String, dynamic>) {
        user = UserModel.fromJson(userJson);
      }

      if (token == null || token.isEmpty) {
        throw Exception('Token non presente nella risposta di $action.');
      }

      return AuthResult(token: token, user: user);
    }

    final data = _safeDecode(response.body);
    final message = data['message'] ?? response.body;
    throw Exception('Errore durante $action: $message');
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      return (jsonDecode(body) as Map<String, dynamic>?) ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}

class AuthResult {
  final String token;
  final UserModel? user;

  const AuthResult({
    required this.token,
    this.user,
  });
}
