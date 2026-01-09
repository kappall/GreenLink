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
    r'9b1c2244a76324f4ff576b414636ec6fa0566f18';

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

String _$postsHash() => r'5e6b7f70ac23b48985127a33a3cbac5770299619';

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
