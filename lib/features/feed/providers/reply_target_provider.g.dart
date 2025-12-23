// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_target_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReplyTarget)
const replyTargetProvider = ReplyTargetProvider._();

final class ReplyTargetProvider
    extends $NotifierProvider<ReplyTarget, ReplyTargetState?> {
  const ReplyTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'replyTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$replyTargetHash();

  @$internal
  @override
  ReplyTarget create() => ReplyTarget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReplyTargetState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReplyTargetState?>(value),
    );
  }
}

String _$replyTargetHash() => r'e4724a8cfe5c7ab93168fd9fb0327feba7b9e81a';

abstract class _$ReplyTarget extends $Notifier<ReplyTargetState?> {
  ReplyTargetState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReplyTargetState?, ReplyTargetState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReplyTargetState?, ReplyTargetState?>,
              ReplyTargetState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
