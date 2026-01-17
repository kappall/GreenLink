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
        isAutoDispose: false,
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

String _$commentSortHash() => r'75620f045017e1bd78928881eaa7bcd542d8ab97';

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
         isAutoDispose: false,
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

String _$commentsHash() => r'5016a50cb8f80fdd46eaf5ad2af94698f9ff212f';

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
        isAutoDispose: false,
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

@ProviderFor(commentsByUserId)
const commentsByUserIdProvider = CommentsByUserIdFamily._();

final class CommentsByUserIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CommentModel>>,
          List<CommentModel>,
          FutureOr<List<CommentModel>>
        >
    with
        $FutureModifier<List<CommentModel>>,
        $FutureProvider<List<CommentModel>> {
  const CommentsByUserIdProvider._({
    required CommentsByUserIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'commentsByUserIdProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsByUserIdHash();

  @override
  String toString() {
    return r'commentsByUserIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CommentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CommentModel>> create(Ref ref) {
    final argument = this.argument as int;
    return commentsByUserId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsByUserIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsByUserIdHash() => r'db8bd6148b94ddd0aeea0374450951636cae2615';

final class CommentsByUserIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CommentModel>>, int> {
  const CommentsByUserIdFamily._()
    : super(
        retry: null,
        name: r'commentsByUserIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CommentsByUserIdProvider call(int userId) =>
      CommentsByUserIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'commentsByUserIdProvider';
}
