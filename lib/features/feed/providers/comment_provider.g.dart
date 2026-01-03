// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentSort)
const commentSortProvider = CommentSortProvider._();

final class CommentSortProvider
    extends $NotifierProvider<CommentSort, CommentSortCriteria> {
  const CommentSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentSortHash();

  @$internal
  @override
  CommentSort create() => CommentSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentSortCriteria value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentSortCriteria>(value),
    );
  }
}

String _$commentSortHash() => r'7c121553f797b2e39543a3501c4b68cdcbffde3f';

abstract class _$CommentSort extends $Notifier<CommentSortCriteria> {
  CommentSortCriteria build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CommentSortCriteria, CommentSortCriteria>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommentSortCriteria, CommentSortCriteria>,
              CommentSortCriteria,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Comments)
const commentsProvider = CommentsFamily._();

final class CommentsProvider
    extends $AsyncNotifierProvider<Comments, List<CommentModel>> {
  const CommentsProvider._({
    required CommentsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'commentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsHash();

  @override
  String toString() {
    return r'commentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Comments create() => Comments();

  @override
  bool operator ==(Object other) {
    return other is CommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsHash() => r'4a9aad27bfd828a55c684290b8ab0ac47afe5f4c';

final class CommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          Comments,
          AsyncValue<List<CommentModel>>,
          List<CommentModel>,
          FutureOr<List<CommentModel>>,
          int
        > {
  const CommentsFamily._()
    : super(
        retry: null,
        name: r'commentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentsProvider call(int contentId) =>
      CommentsProvider._(argument: contentId, from: this);

  @override
  String toString() => r'commentsProvider';
}

abstract class _$Comments extends $AsyncNotifier<List<CommentModel>> {
  late final _$args = ref.$arg as int;
  int get contentId => _$args;

  FutureOr<List<CommentModel>> build(int contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<CommentModel>>, List<CommentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CommentModel>>, List<CommentModel>>,
              AsyncValue<List<CommentModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
