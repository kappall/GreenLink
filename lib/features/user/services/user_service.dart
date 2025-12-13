import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:greenlinkapp/features/user/models/user_model.dart';

class UserService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<void> deleteAccount({
    required int userId,
    required String token,
  }) async {

    final response = await http.delete(
      Uri.parse('$_baseUrl/user/${userId.toString()}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    final data = _safeDecode(response.body);
    final message = data['message'] ?? response.body;

    throw Exception(
      "Errore durante l'eliminazione dell'account: $message",
    );
  }

  Future<UserModel> fetchCurrentUser({
    required String token,
  }) async {

    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = _safeDecode(response.body);
      final rawUser = data['user'] ?? data;
      if (rawUser is! Map<String, dynamic>) {
        throw Exception(
          'Risposta inattesa da /me: ${response.body}',
        );
      }

      return UserModel.fromJson(rawUser);
    }

    final data = _safeDecode(response.body);
    final message = data['message'] ?? response.body;
    throw Exception('Errore durante il fetch dell\'utente: $message');
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      return (jsonDecode(body) as Map<String, dynamic>?) ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

}
