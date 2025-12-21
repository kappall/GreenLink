import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class PostsNotifier extends AsyncNotifier<List<PostModel>> {
  final PostService _postService = PostService();
  int? _userId;

  @override
  Future<List<PostModel>> build() async {
    return _fetchPosts(userId: _userId);
  }

  Future<void> refresh({int? userId}) async {
    if (userId != null) _userId = userId;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPosts(userId: _userId));
  }

  Future<void> refreshAll() async {
    _userId = null;

    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPosts);
  }

  Future<List<PostModel>> _fetchPosts({int? userId}) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (userId != null && userId > 0) {
      return _postService.fetchPosts(token: token!, userId: userId);
    }

    return _postService.fetchAllPosts(token: token);
  }

  Future<void> reportPost({
    required PostModel post,
    required String reason,
  }) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    final userId = authState.asData?.value.user?.id;

    if (token == null || userId == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.reportPost(
      token: token,
      post: post,
      reason: reason,
      currentUserId: userId,
    );
  }

  Future<void> deletePost(int postId) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    if (token == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.deletePost(token: token, postId: postId);
    refreshAll();
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);
