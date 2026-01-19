import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/location/providers/location_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

part 'post_provider.g.dart';

enum PostSortCriteria { date, votes, proximity }

class PostFilter {
  final String locationQuery;
  final LatLng? resolvedLocation;
  final DateTime? startDate;

  PostFilter({this.locationQuery = '', this.resolvedLocation, this.startDate});

  PostFilter copyWith({
    String? locationQuery,
    LatLng? resolvedLocation,
    DateTime? startDate,
  }) {
    return PostFilter(
      locationQuery: locationQuery ?? this.locationQuery,
      resolvedLocation: resolvedLocation ?? this.resolvedLocation,
      startDate: startDate ?? this.startDate,
    );
  }
}

class PostFilterNotifier extends Notifier<PostFilter> {
  @override
  PostFilter build() {
    _initializeDefaultLocation();
    return PostFilter();
  }

  Future<void> _initializeDefaultLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(
        resolvedLocation: LatLng(position.latitude, position.longitude),
      );
    } catch (_) {}
  }

  Future<void> updateFilter({
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
      locationQuery: locationQuery,
      resolvedLocation: resolved,
      startDate: clearDate ? null : startDate,
    );
  }

  void reset() {
    state = PostFilter();
    _initializeDefaultLocation();
  }
}

final postFilterProvider = NotifierProvider<PostFilterNotifier, PostFilter>(
  PostFilterNotifier.new,
);

class PostSortCriteriaNotifier extends Notifier<PostSortCriteria> {
  @override
  PostSortCriteria build() => PostSortCriteria.date;

  void setCriteria(PostSortCriteria criteria) => state = criteria;

  void reset() {
    state = PostSortCriteria.date;
  }
}

final postSortCriteriaProvider =
    NotifierProvider<PostSortCriteriaNotifier, PostSortCriteria>(
      PostSortCriteriaNotifier.new,
    );

class CreatePostState {
  final PostCategory? category;
  final List<XFile> images;
  final String description;
  final String? locationLabel;
  final double? latitude;
  final double? longitude;
  final bool isLocating;
  final bool isPublishing;

  CreatePostState({
    this.category,
    this.images = const [],
    this.description = '',
    this.locationLabel,
    this.latitude,
    this.longitude,
    this.isLocating = false,
    this.isPublishing = false,
  });

  CreatePostState copyWith({
    PostCategory? category,
    List<XFile>? images,
    String? description,
    String? locationLabel,
    double? latitude,
    double? longitude,
    bool? isLocating,
    bool? isPublishing,
  }) {
    return CreatePostState(
      category: category ?? this.category,
      images: images ?? this.images,
      description: description ?? this.description,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLocating: isLocating ?? this.isLocating,
      isPublishing: isPublishing ?? this.isPublishing,
    );
  }

  bool get canPublish =>
      category != null && locationLabel != null && !isPublishing;
}

@Riverpod(keepAlive: true)
class CreatePostNotifier extends _$CreatePostNotifier {
  final _postService = PostService.instance;
  final _picker = ImagePicker();

  @override
  CreatePostState build() => CreatePostState();

  void setCategory(PostCategory? category) {
    state = state.copyWith(category: category);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        state = state.copyWith(images: [...state.images, ...images]);
      }
    } catch (_) {}
  }

  void removeImage(int index) {
    final newList = List<XFile>.from(state.images)..removeAt(index);
    state = state.copyWith(images: newList);
  }

  Future<void> useCurrentLocation() async {
    state = state.copyWith(isLocating: true);
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final first = placemarks.isNotEmpty ? placemarks.first : null;
      final address = [
        first?.street,
        first?.locality,
        first?.administrativeArea,
        first?.country,
      ].where((p) => p != null && p.trim().isNotEmpty).join(', ');

      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        locationLabel: address.isNotEmpty ? address : 'Posizione Attuale',
        isLocating: false,
      );
    } catch (_) {
      state = state.copyWith(isLocating: false);
    }
  }

  Future<bool> setManualLocation(String addressInput) async {
    if (addressInput.isEmpty) return false;
    state = state.copyWith(isLocating: true);

    try {
      List<geo.Location> locations = await geo.locationFromAddress(
        addressInput,
      );
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final placemarks = await geo.placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );

        String resolvedLabel = addressInput;
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            p.street,
            p.locality,
            p.administrativeArea,
          ].where((s) => s != null && s.isNotEmpty).toList();
          if (parts.isNotEmpty) {
            resolvedLabel = parts.join(", ");
          }
        }

        state = state.copyWith(
          latitude: loc.latitude,
          longitude: loc.longitude,
          locationLabel: resolvedLabel,
          isLocating: false,
        );
        return true;
      }
    } catch (_) {}

    state = state.copyWith(isLocating: false);
    return false;
  }

  Future<bool> publishPost() async {
    if (!state.canPublish) return false;
    state = state.copyWith(isPublishing: true);

    try {
      final auth = ref.read(authProvider).value!;
      await _postService.createPost(
        token: auth.token!,
        authorId: auth.user!.id,
        description: state.description,
        latitude: state.latitude!,
        longitude: state.longitude!,
        category: state.category!.name,
        media: state.images,
      );

      ref.invalidate(postsProvider);

      state = CreatePostState();
      return true;
    } catch (_) {
      state = state.copyWith(isPublishing: false);
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
class Posts extends _$Posts {
  final _postService = PostService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<PostModel>> build(int? userId) async {
    return _fetchPage(1);
  }

  Future<PaginatedResult<PostModel>> _fetchPage(int page) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final paginatedResult = await _postService.fetchAllPosts(
      token: token,
      userId: this.userId,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return paginatedResult.copyWith(
      page: page,
      hasMore:
          paginatedResult.items.isNotEmpty &&
          paginatedResult.items.length < paginatedResult.totalItems,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !state.value!.hasMore) return;
    _isLoadingMore = true;

    try {
      final nextPage = state.value!.page + 1;
      final newPage = await _fetchPage(nextPage);
      final currentPosts = state.value?.items ?? [];

      state = AsyncValue.data(
        state.value!.copyWith(
          items: [...currentPosts, ...newPage.items],
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<PostModel> fetchPostById(String postId) async {
    final authState = ref.read(authProvider).value;
    final token = authState?.token;

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      final post = await _postService.fetchPostById(
        token: token,
        postId: postId,
      );
      return post;
    } catch (e) {
      print('Failed to fetch post by ID: $e');
      throw Exception('Could not load the post.');
    }
  }

  Future<void> reportContent({
    required int contentId,
    required String reason,
  }) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    final currentUserId = authState.asData?.value.user?.id;

    if (token == null || currentUserId == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.reportContent(
      token: token,
      contentId: contentId,
      reason: reason,
    );
  }

  Future<void> deletePost(int postId) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    if (token == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.deletePost(token: token, postId: postId);
    ref.invalidate(postsProvider);
  }

  Future<void> votePost(int postId, bool hasVoted) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) return;

    final previousState = state;

    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.copyWith(
          items: state.value!.items.map((post) {
            if (post.id == postId) {
              final isCurrentlyVoted = post.hasVoted;
              return post.copyWith(
                hasVoted: !isCurrentlyVoted,
                votesCount: isCurrentlyVoted
                    ? post.votesCount - 1
                    : post.votesCount + 1,
              );
            }
            return post;
          }).toList(),
        ),
      );
    }

    try {
      await _postService.votePost(
        token: authState.token!,
        postId: postId,
        hasVoted: hasVoted,
      );
    } catch (e) {
      state = previousState;
    }
  }
}

@Riverpod(keepAlive: true)
class PostsByDistance extends _$PostsByDistance {
  final _postService = PostService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<PostModel>> build() async {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      data: (userLocation) {
        if (userLocation == null) {
          return PaginatedResult<PostModel>(hasMore: false);
        }
        return _fetchPage(1, userLocation.latitude, userLocation.longitude);
      },
      loading: () =>
          PaginatedResult<PostModel>(hasMore: false), // Handle loading state
      error: (err, stack) =>
          PaginatedResult<PostModel>(hasMore: false), // Handle error state
    );
  }

  Future<PaginatedResult<PostModel>> _fetchPage(
    int page,
    double lat,
    double lng,
  ) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final paginatedResult = await _postService.fetchPostsByDistance(
      token: token,
      latitude: lat,
      longitude: lng,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return paginatedResult.copyWith(
      page: page,
      hasMore:
          paginatedResult.items.isNotEmpty &&
          paginatedResult.items.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    final userLocation = ref.read(userLocationProvider).value;
    if (_isLoadingMore || !state.value!.hasMore || userLocation == null) return;
    _isLoadingMore = true;

    try {
      final nextPage = state.value!.page + 1;
      final newPage = await _fetchPage(
        nextPage,
        userLocation.latitude,
        userLocation.longitude,
      );
      final currentPosts = state.value?.items ?? [];
      final allPosts = [...currentPosts, ...newPage.items];
      final uniquePosts = allPosts.toSet().toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          items: uniquePosts,
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

final sortedPostsProvider =
    Provider.autoDispose<AsyncValue<PaginatedResult<PostModel>>>((ref) {
      final criteria = ref.watch(postSortCriteriaProvider);

      if (criteria == PostSortCriteria.proximity) {
        return ref.watch(postsByDistanceProvider);
      }

      final postsAsync = ref.watch(postsProvider(null));
      final filter = ref.watch(postFilterProvider);

      return postsAsync.whenData((paginated) {
        final filteredPosts = paginated.items.where((post) {
          final matchesDate =
              filter.startDate == null ||
              (post.createdAt != null &&
                  post.createdAt!.isAfter(filter.startDate!));
          return matchesDate;
        }).toList();

        if (criteria == PostSortCriteria.votes) {
          filteredPosts.sort(
            (a, b) => b.votesCount.compareTo(a.votesCount),
          ); // TODO: return ref.watch(postsByVotesProvider);
        }

        return paginated.copyWith(items: filteredPosts);
      });
    });
