import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

part 'post_provider.g.dart';

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
      category != null &&
      images.isNotEmpty &&
      description.trim().isNotEmpty &&
      locationLabel != null &&
      !isPublishing;
}

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  final _postService = PostService();
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

      // Refresh user posts and global feed
      ref.invalidate(postsProvider);

      state = CreatePostState(); // Reset state
      return true;
    } catch (_) {
      state = state.copyWith(isPublishing: false);
      return false;
    }
  }
}

@riverpod
class Posts extends _$Posts {
  final _postService = PostService();

  @override
  FutureOr<List<PostModel>> build(int? userId) async {
    return _fetchPosts(uId: userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPosts(uId: userId));
  }

  Future<List<PostModel>> _fetchPosts({int? uId}) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (token == null) throw Exception('Token richiesto');
    if (uId != null && uId > 0) {
      return _postService.fetchPosts(token: token, userId: uId);
    }
    return _postService.fetchAllPosts(token: token);
  }

  Future<void> reportPost({
    required PostModel post,
    required String reason,
  }) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    final currentUserId = authState.asData?.value.user?.id;

    if (token == null || currentUserId == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.reportPost(
      token: token,
      post: post,
      reason: reason,
      currentUserId: currentUserId,
    );
  }

  Future<void> deletePost(int postId) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;
    if (token == null) {
      throw Exception('Utente non autenticato');
    }

    await _postService.deletePost(token: token, postId: postId);
    await refresh();
  }

  Future<void> votePost(int postId, bool hasVoted) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) return;

    final previousState = state;

    // Aggiornamento Ottimistico locale
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.map((post) {
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

// ordine desc automatico
final sortedPostsProvider = Provider<AsyncValue<List<PostModel>>>((ref) {
  final postsAsync = ref.watch(postsProvider(null));
  final criteria = ref.watch(postSortCriteriaProvider);
  final filter = ref.watch(postFilterProvider);

  return postsAsync.whenData((posts) {
    var filtered = posts.where((post) {
      final matchesVotes = post.votesCount >= filter.minVotes;
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
          return b.votesCount.compareTo(a.votesCount);
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
