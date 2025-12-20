import 'dart:convert';

import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';

  Future<List<PostModel>> fetchAllPosts({required String? token}) {
    final uri = Uri.parse('$_baseUrl/posts');
    return _requestPosts(uri: uri, token: token);
  }

  Future<List<PostModel>> fetchPosts({
    required String token,
    int? userId,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts').replace(
      queryParameters: {
        if (userId != null && userId > 0) 'user': userId.toString(),
      },
    );

    return _requestPosts(uri: uri, token: token);
  }

  Future<List<PostModel>> _requestPosts({
    required Uri uri,
    required String? token,
  }) async {
    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero dei post: $message');
    }

    final decoded = jsonDecode(response.body);
    final dynamic rawList = switch (decoded) {
      final Map<String, dynamic> map => map['posts'] ?? map['data'] ?? map,
      final List<dynamic> list => list,
      _ => decoded,
    };
    if (rawList is! List) {
      throw Exception('Risposta inattesa da /posts: $rawList');
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
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
