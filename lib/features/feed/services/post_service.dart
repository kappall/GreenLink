import 'dart:convert';
import 'dart:developer';

import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostService {
  PostService._();
  static final PostService instance = PostService._();

  static const _baseUrl = 'https://greenlink.tommasodeste.it/api';
  final Map<String, PaginatedResult<PostModel>> _cache = {};

  void _clearCache() {
    _cache.clear();
  }

  Future<PaginatedResult<PostModel>> fetchAllPosts({
    required String? token,
    required int? userId,
    int? skip,
    int? limit,
  }) {
    final uri = Uri.parse('$_baseUrl/posts').replace(
      queryParameters: {
        'user': userId?.toString() ?? '',
        'sort': 'id',
        'order': 'desc',
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestPosts(uri: uri, token: token);
  }

  Future<PaginatedResult<PostModel>> fetchPostsByDistance({
    required String? token,
    required double latitude,
    required double longitude,
    int? skip,
    int? limit,
  }) {
    final uri = Uri.parse('$_baseUrl/posts').replace(
      queryParameters: {
        'sort': 'distance',
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'skip': skip?.toString() ?? '0',
        'limit': limit?.toString() ?? '20',
      },
    );

    return _requestPosts(uri: uri, token: token);
  }

  Future<PaginatedResult<PostModel>> fetchUserPosts({
    required String token,
    required int userId,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts').replace(
      queryParameters: {
        'user': userId.toString(),
        'sort': 'id',
        'order': 'desc',
      },
    );

    return _requestPosts(uri: uri, token: token);
  }

  Future<PostModel> fetchPostById({
    required String token,
    required String postId,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/post/$postId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero dei post: $message');
    }

    final decoded = jsonDecode(response.body);
    final post = PostModel.fromJson(decoded);
    return post;
  }

  Future<PaginatedResult<PostModel>> _requestPosts({
    required Uri uri,
    required String? token,
  }) async {
    final cacheKey = uri.toString();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il recupero dei post: $message');
    }

    final totalItems = int.tryParse(response.headers['total-items'] ?? '') ?? 0;

    final decoded = jsonDecode(response.body);
    final dynamic rawList = switch (decoded) {
      final Map<String, dynamic> map => map['posts'] ?? map['data'] ?? map,
      final List<dynamic> list => list,
      _ => decoded,
    };
    if (rawList is! List) {
      throw Exception('Risposta inattesa da /posts: $rawList');
    }
    final posts = rawList
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();

    final result = PaginatedResult(items: posts, totalItems: totalItems);
    _cache[cacheKey] = result;
    return result;
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
    final postId = decoded['id'] as int;

    if (media.isNotEmpty) {
      for (var file in media) {
        await uploadMedia(token: token, postId: postId, file: file);
      }
    }
    _clearCache();
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

    String mimeSubtype = (extension == 'jpg') ? 'jpeg' : extension;

    request.fields['type'] = extension;
    request.fields['content'] = postId.toString();

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      file.path,
      filename: file.name,
      contentType: http.MediaType('image', mimeSubtype),
    );
    request.files.add(multipartFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      throw Exception('Errore durante il caricamento del media: $message');
    }
    _clearCache();
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
    _clearCache();
  }

  Future<void> reportContent({
    required String token,
    required int contentId,
    required String reason,
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
        "content": {"id": contentId},
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      FeedbackUtils.logError(message);
      throw Exception('Errore durante la segnalazione');
    }
    _clearCache();
  }

  Future<void> deletePost({required String token, required int postId}) async {
    final uri = Uri.parse('$_baseUrl/post/$postId');
    final response = await http.delete(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _errorMessage(response);
      log(message);
      throw Exception('Errore durante la cancellazione del post');
    }
    _clearCache();
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
