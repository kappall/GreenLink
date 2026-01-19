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
        isAutoDispose: false,
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
    r'0b028652e8c5bcebdd9611d6477a1d2c3bfe6ef3';

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
    extends $AsyncNotifierProvider<Posts, PaginatedResult<PostModel>> {
  const PostsProvider._({
    required PostsFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'postsProvider',
         isAutoDispose: false,
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

String _$postsHash() => r'd6165414d61554e6d30b7daca0823ed4a6dce90b';

final class PostsFamily extends $Family
    with
        $ClassFamilyOverride<
          Posts,
          AsyncValue<PaginatedResult<PostModel>>,
          PaginatedResult<PostModel>,
          FutureOr<PaginatedResult<PostModel>>,
          int?
        > {
  const PostsFamily._()
    : super(
        retry: null,
        name: r'postsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PostsProvider call(int? userId) =>
      PostsProvider._(argument: userId, from: this);

  @override
  String toString() => r'postsProvider';
}

abstract class _$Posts extends $AsyncNotifier<PaginatedResult<PostModel>> {
  late final _$args = ref.$arg as int?;
  int? get userId => _$args;

  FutureOr<PaginatedResult<PostModel>> build(int? userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<PostModel>>,
              PaginatedResult<PostModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<PostModel>>,
                PaginatedResult<PostModel>
              >,
              AsyncValue<PaginatedResult<PostModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PostsByDistance)
const postsByDistanceProvider = PostsByDistanceProvider._();

final class PostsByDistanceProvider
    extends
        $AsyncNotifierProvider<PostsByDistance, PaginatedResult<PostModel>> {
  const PostsByDistanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsByDistanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsByDistanceHash();

  @$internal
  @override
  PostsByDistance create() => PostsByDistance();
}

String _$postsByDistanceHash() => r'8871478efcb770795ed08f8be10a6c75d3c39c43';

abstract class _$PostsByDistance
    extends $AsyncNotifier<PaginatedResult<PostModel>> {
  FutureOr<PaginatedResult<PostModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<PostModel>>,
              PaginatedResult<PostModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<PostModel>>,
                PaginatedResult<PostModel>
              >,
              AsyncValue<PaginatedResult<PostModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
