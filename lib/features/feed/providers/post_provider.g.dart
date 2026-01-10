// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostNotifier)
const createPostProvider = CreatePostNotifierProvider._();

final class CreatePostNotifierProvider
    extends $NotifierProvider<CreatePostNotifier, CreatePostState> {
  const CreatePostNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostNotifierHash();

  @$internal
  @override
  CreatePostNotifier create() => CreatePostNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatePostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatePostState>(value),
    );
  }
}

String _$createPostNotifierHash() =>
    r'7b35933233dd51b9ba4a54a350628b2c4fc11c9f';

abstract class _$CreatePostNotifier extends $Notifier<CreatePostState> {
  CreatePostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CreatePostState, CreatePostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreatePostState, CreatePostState>,
              CreatePostState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Posts)
const postsProvider = PostsFamily._();

final class PostsProvider
    extends $AsyncNotifierProvider<Posts, PaginatedPosts> {
  const PostsProvider._({
    required PostsFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'postsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsHash();

  @override
  String toString() {
    return r'postsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Posts create() => Posts();

  @override
  bool operator ==(Object other) {
    return other is PostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsHash() => r'762fa924af8ebcd57635209ce200893a80ae4d95';

final class PostsFamily extends $Family
    with
        $ClassFamilyOverride<
          Posts,
          AsyncValue<PaginatedPosts>,
          PaginatedPosts,
          FutureOr<PaginatedPosts>,
          int?
        > {
  const PostsFamily._()
    : super(
        retry: null,
        name: r'postsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostsProvider call(int? userId) =>
      PostsProvider._(argument: userId, from: this);

  @override
  String toString() => r'postsProvider';
}

abstract class _$Posts extends $AsyncNotifier<PaginatedPosts> {
  late final _$args = ref.$arg as int?;
  int? get userId => _$args;

  FutureOr<PaginatedPosts> build(int? userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<PaginatedPosts>, PaginatedPosts>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaginatedPosts>, PaginatedPosts>,
              AsyncValue<PaginatedPosts>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PostsByDistance)
const postsByDistanceProvider = PostsByDistanceProvider._();

final class PostsByDistanceProvider
    extends $AsyncNotifierProvider<PostsByDistance, PaginatedPosts> {
  const PostsByDistanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsByDistanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsByDistanceHash();

  @$internal
  @override
  PostsByDistance create() => PostsByDistance();
}

String _$postsByDistanceHash() => r'1b9dab68585303af4cd5f4f04c26b2964f2e7b64';

abstract class _$PostsByDistance extends $AsyncNotifier<PaginatedPosts> {
  FutureOr<PaginatedPosts> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PaginatedPosts>, PaginatedPosts>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaginatedPosts>, PaginatedPosts>,
              AsyncValue<PaginatedPosts>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(mapPosts)
const mapPostsProvider = MapPostsProvider._();

final class MapPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          List<PostModel>,
          FutureOr<List<PostModel>>
        >
    with $FutureModifier<List<PostModel>>, $FutureProvider<List<PostModel>> {
  const MapPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPostsHash();

  @$internal
  @override
  $FutureProviderElement<List<PostModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PostModel>> create(Ref ref) {
    return mapPosts(ref);
  }
}

String _$mapPostsHash() => r'c6608eb34a62d4296f0535201e7477d5452aef06';
