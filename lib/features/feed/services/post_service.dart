import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<int> createPost({
    required String token,
    required String description,
    required double latitude,
    required double longitude,
    required String category,
    required int authorId,
    List<XFile> media = const [],
  }) async {
    final uri = Uri.parse('$_baseUrl/post');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "category": category,
        "author": authorId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la creazione del post: $message');
    }

    final decoded = jsonDecode(response.body);
    debugPrint(decoded.toString());
    final postId = decoded['id'] as int;

    if (media.isNotEmpty) {
      for (var file in media) {
        await uploadMedia(token: token, postId: postId, file: file);
      }
    }

    return postId;
  }

  Future<void> uploadMedia({
    required String token,
    required int postId,
    required XFile file,
  }) async {
    final uri = Uri.parse('$_baseUrl/media');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    String extension = file.path.split('.').last.toLowerCase();
    if (extension == 'jpeg') extension = 'jpg';

    // Per il MIME type ufficiale, jpg deve essere jpeg
    String mimeSubtype = (extension == 'jpg') ? 'jpeg' : extension;

    request.fields['type'] = extension;
    request.fields['content'] = postId.toString();

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      file.path,
      filename: file.name,
      contentType: MediaType('image', mimeSubtype),
    );
    request.files.add(multipartFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il caricamento del media: $message');
    }
  }

  Future<void> votePost({
    required String token,
    required int postId,
    required bool hasVoted,
  }) async {
    final uri = Uri.parse('$_baseUrl/post/$postId/vote');
    final method = hasVoted ? http.delete : http.post;
    final response = await method(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la votazione: $message');
    }
  }

  Future<void> reportPost({
    required String token,
    required PostModel post,
    required String reason,
    required int currentUserId,
  }) async {
    final uri = Uri.parse('$_baseUrl/report');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "reason": reason,
        "author": {"id": currentUserId},
        "content": {
          "id": post.id,
          "description": post.description,
          "author": {"id": post.author.id},
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante la segnalazione: $message');
    }
  }

  Future<void> deletePost({required String token, required int postId}) async {
    final uri = Uri.parse('$_baseUrl/post/$postId');
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
