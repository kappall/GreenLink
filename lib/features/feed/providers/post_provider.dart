import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/services/post_service.dart';

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
    state = await AsyncValue.guard(
      () => _fetchPosts(userId: _userId),
    );
  }

  Future<void> refreshAll() async {
    _userId = null;

    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPosts);
  }

  Future<List<PostModel>> _fetchPosts({int? userId}) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (token == null || token.isEmpty) {
      return <PostModel>[];
    }

    if (userId != null && userId > 0) {
      return _postService.fetchPosts(
        token: token,
        userId: userId,
      );
    }

    return _postService.fetchAllPosts(token: token);
  }
}

final postsProvider =
    AsyncNotifierProvider<PostsNotifier, List<PostModel>>(PostsNotifier.new);
