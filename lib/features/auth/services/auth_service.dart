import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../user/models/user_model.dart';

class AuthService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final payload = {'email': email, 'password': password};

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

  Future<AuthResult> registerPartner({
    required String token,
    required String password,
  }) async {
    final payload = {'password': password};

    final response = await http.post(
      Uri.parse('$_baseUrl/partner/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    return _handleAuthResponse(response, 'registrazione');
  }

  Future<UserModel> fetchCurrentUser({required String token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = _safeDecode(response.body);
      final rawUser = data['user'] ?? data;
      if (rawUser is! Map<String, dynamic>) {
        throw Exception('Risposta inattesa da /me: ${response.body}');
      }

      return UserModel.fromJson(rawUser);
    }

    final data = _safeDecode(response.body);
    final message = data['message'] ?? response.body;
    throw Exception('Errore durante il fetch dell\'utente: $message');
  }

  Future<void> deleteAccount({
    required int userId,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/${userId.toString()}'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    final data = _safeDecode(response.body);
    final message = data['message'] ?? response.body;

    throw Exception("Errore durante l'eliminazione dell'account: $message");
  }

  AuthResult _handleAuthResponse(http.Response response, String action) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = _safeDecode(response.body);
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('Token non presente nella risposta di $action.');
      }
      final decoded = JwtDecoder.decode(token);
      final userId = decoded['id'];
      final email = decoded['email'];

      return AuthResult(token: token, userId: userId, email: email);
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
  final int userId;
  final String email;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.email,
  });
}
