import 'dart:convert';

import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../user/models/user_model.dart';

class AuthService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/login');
    final payload = {'email': email, 'password': password};

    try {
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseAuthResponse(response.body);
      }

      FeedbackUtils.logError(
        "Login failed (${response.statusCode}): ${response.body}",
      );
      throw Exception('Email o password non corrette. Riprova.');
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Connection error during login: $e");
      throw Exception('Errore di connessione. Controlla la tua rete.');
    }
  }

  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    final payload = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseAuthResponse(response.body);
      }

      FeedbackUtils.logError(
        "Registration failed (${response.statusCode}): ${response.body}",
      );
      throw Exception(
        'Impossibile creare l\'account. L\'email o lo username potrebbero essere già in uso.',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Connection error during registration: $e");
      throw Exception('Errore di connessione. Riprova tra poco.');
    }
  }

  Future<AuthResult> registerPartner({
    required String token,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/partner/register');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseAuthResponse(response.body);
      }

      FeedbackUtils.logError(
        "Partner activation failed (${response.statusCode}): ${response.body}",
      );
      throw Exception('Il codice di attivazione non è valido o è scaduto.');
    } catch (e) {
      if (e is Exception) rethrow;
      FeedbackUtils.logError("Connection error during partner activation: $e");
      throw Exception('Errore di rete. Controlla la tua connessione.');
    }
  }

  Future<UserModel> fetchCurrentUser({required String token}) async {
    final uri = Uri.parse('$_baseUrl/me');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = _safeDecode(response.body);
        final rawUser = data['user'] ?? data;
        if (rawUser is! Map<String, dynamic>) {
          throw Exception('Risposta non valida dal server.');
        }
        return UserModel.fromJson(rawUser);
      }

      FeedbackUtils.logError(
        "Fetch current user failed (${response.statusCode}): ${response.body}",
      );
      throw Exception('Sessione non valida. Effettua di nuovo l\'accesso.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Errore nel caricamento del profilo.');
    }
  }

  Future<void> deleteAccount({
    required int userId,
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/user/${userId.toString()}');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) return;

      FeedbackUtils.logError(
        "Delete account failed (${response.statusCode}): ${response.body}",
      );
      throw Exception(
        'Non è stato possibile eliminare l\'account. Riprova più tardi.',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Errore durante l\'eliminazione.');
    }
  }

  AuthResult _parseAuthResponse(String body) {
    final data = _safeDecode(body);
    final token = data['token'] as String?;

    if (token == null || token.isEmpty) {
      FeedbackUtils.logError("Token missing in response: $body");
      throw Exception('Errore nella risposta del server.');
    }

    try {
      final decoded = JwtDecoder.decode(token);
      return AuthResult(
        token: token,
        userId: decoded['id'],
        email: decoded['email'],
      );
    } catch (e) {
      FeedbackUtils.logError("JWT decoding failed: $e");
      throw Exception('Errore nell\'accesso. Riprova.');
    }
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
