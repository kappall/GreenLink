// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$userPostsHash() => r'58e249ec08f47e7fdeea7b64e9144ec346829fcc';

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
