import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:latlong2/latlong.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

enum PostSortCriteria { date, votes, proximity }

class PostFilter {
  final int minVotes;
  final String locationQuery;
  final LatLng? resolvedLocation;
  final DateTime? startDate;

  PostFilter({
    this.minVotes = 0,
    this.locationQuery = '',
    this.resolvedLocation,
    this.startDate,
  });

  PostFilter copyWith({
    int? minVotes,
    String? locationQuery,
    LatLng? resolvedLocation,
    DateTime? startDate,
  }) {
    return PostFilter(
      minVotes: minVotes ?? this.minVotes,
      locationQuery: locationQuery ?? this.locationQuery,
      resolvedLocation: resolvedLocation ?? this.resolvedLocation,
      startDate: startDate ?? this.startDate,
    );
  }
}

class PostFilterNotifier extends Notifier<PostFilter> {
  @override
  PostFilter build() => PostFilter();

  Future<void> updateFilter({
    int? minVotes,
    String? locationQuery,
    DateTime? startDate,
    bool clearDate = false,
  }) async {
    LatLng? resolved = state.resolvedLocation;

    if (locationQuery != null) {
      if (locationQuery.isEmpty) {
        resolved = null;
      } else if (locationQuery != state.locationQuery) {
        try {
          final locations = await geo.locationFromAddress(locationQuery);
          if (locations.isNotEmpty) {
            resolved = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );
          }
        } catch (_) {
          resolved = null;
        }
      }
    }

    state = state.copyWith(
      minVotes: minVotes,
      locationQuery: locationQuery,
      resolvedLocation: resolved,
      startDate: clearDate ? null : startDate,
    );
  }
}

final postFilterProvider = NotifierProvider<PostFilterNotifier, PostFilter>(
  PostFilterNotifier.new,
);

class PostSortCriteriaNotifier extends Notifier<PostSortCriteria> {
  @override
  PostSortCriteria build() => PostSortCriteria.date;

  void setCriteria(PostSortCriteria criteria) => state = criteria;
}

final postSortCriteriaProvider =
    NotifierProvider<PostSortCriteriaNotifier, PostSortCriteria>(
      PostSortCriteriaNotifier.new,
    );

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
    refresh();
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);

// ordine desc automatico
final sortedPostsProvider = Provider<AsyncValue<List<PostModel>>>((ref) {
  final postsAsync = ref.watch(postsProvider);
  final criteria = ref.watch(postSortCriteriaProvider);
  final filter = ref.watch(postFilterProvider);

  return postsAsync.whenData((posts) {
    var filtered = posts.where((post) {
      final matchesVotes = post.votes_count >= filter.minVotes;
      final matchesDate =
          filter.startDate == null ||
          (post.createdAt != null &&
              post.createdAt!.isAfter(filter.startDate!));
      return matchesVotes && matchesDate;
    }).toList();

    final distance = const Distance();
    filtered.sort((a, b) {
      switch (criteria) {
        case PostSortCriteria.date:
          final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return dateB.compareTo(dateA);
        case PostSortCriteria.votes:
          return b.votes_count.compareTo(a.votes_count);
        case PostSortCriteria.proximity:
          if (filter.resolvedLocation == null) return 0;
          final distA = distance.as(
            LengthUnit.Meter,
            filter.resolvedLocation!,
            LatLng(a.latitude, a.longitude),
          );
          final distB = distance.as(
            LengthUnit.Meter,
            filter.resolvedLocation!,
            LatLng(b.latitude, b.longitude),
          );
          return distA.compareTo(distB); // ASC, quello più vicino
      }
    });

    return filtered;
  });
});
