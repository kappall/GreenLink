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
    extends $AsyncNotifierProvider<Posts, List<PostModel>> {
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

String _$postsHash() => r'090822bf9bef92a4b0b2828c2ecfb576c2d636cb';

final class PostsFamily extends $Family
    with
        $ClassFamilyOverride<
          Posts,
          AsyncValue<List<PostModel>>,
          List<PostModel>,
          FutureOr<List<PostModel>>,
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

abstract class _$Posts extends $AsyncNotifier<List<PostModel>> {
  late final _$args = ref.$arg as int?;
  int? get userId => _$args;

  FutureOr<List<PostModel>> build(int? userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<PostModel>>, List<PostModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PostModel>>, List<PostModel>>,
              AsyncValue<List<PostModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
