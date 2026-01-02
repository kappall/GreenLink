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
    r'72bcfa199c5544325ec0f544d4f76505f7fab645';

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

@ProviderFor(UserPosts)
const userPostsProvider = UserPostsFamily._();

final class UserPostsProvider
    extends $AsyncNotifierProvider<UserPosts, List<PostModel>> {
  const UserPostsProvider._({
    required UserPostsFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'userPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userPostsHash();

  @override
  String toString() {
    return r'userPostsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserPosts create() => UserPosts();

  @override
  bool operator ==(Object other) {
    return other is UserPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userPostsHash() => r'2ab96ab10cbfb9f1f314985741d7a224580b29bd';

final class UserPostsFamily extends $Family
    with
        $ClassFamilyOverride<
          UserPosts,
          AsyncValue<List<PostModel>>,
          List<PostModel>,
          FutureOr<List<PostModel>>,
          int?
        > {
  const UserPostsFamily._()
    : super(
        retry: null,
        name: r'userPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserPostsProvider call(int? userId) =>
      UserPostsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userPostsProvider';
}

abstract class _$UserPosts extends $AsyncNotifier<List<PostModel>> {
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
