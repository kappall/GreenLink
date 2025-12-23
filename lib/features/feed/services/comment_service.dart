import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/comment_model.dart';

class CommentService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<List<CommentModel>> fetchCommentsByPost({required int postId}) async {
    //TODO test quando va backend
    final response = await http.get(
      Uri.parse('$_baseUrl/comments/$postId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero dei commenti: $message');
    }
    return _parseComments(response.body);
  }

  Future<List<CommentModel>> _parseComments(String responseBody) async {
    final decoded = jsonDecode(responseBody);
    debugPrint(responseBody);
    if (decoded['comments']! is List) {
      throw Exception(
        'Errore durante il recupero dei commenti: malformattato: $responseBody',
      );
    }
    return decoded['comments']
        .map<CommentModel>((comment) => CommentModel.fromJson(comment))
        .toList();
  }

  Future<void> postComment({
    required String token,
    required int contentId,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/comment'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "description": description,
        "content": {"id": contentId},
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la creazione del commento: $message');
    }
  }

  Future<void> deleteComment({
    required String token,
    required int commentId,
  }) async {
    final uri = Uri.parse('$_baseUrl/comment/$commentId');
    final response = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la segnalazione: $message');
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['message']?.toString() ?? response.body;
    } catch (_) {
      return response.body;
    }
  }
}
