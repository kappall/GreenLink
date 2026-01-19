// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapFilterState)
const mapFilterStateProvider = MapFilterStateProvider._();

final class MapFilterStateProvider
    extends $NotifierProvider<MapFilterState, MapFilter> {
  const MapFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapFilterStateHash();

  @$internal
  @override
  MapFilterState create() => MapFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapFilter>(value),
    );
  }
}

String _$mapFilterStateHash() => r'2881bb983837084cb8805aed262e90d84997cb74';

abstract class _$MapFilterState extends $Notifier<MapFilter> {
  MapFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MapFilter, MapFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MapFilter, MapFilter>,
              MapFilter,
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
        isAutoDispose: false,
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

String _$mapPostsHash() => r'4a1521f7bdd0e7c4c3ef7e8ef59c17ba05bf6dcf';

@ProviderFor(mapEvents)
const mapEventsProvider = MapEventsProvider._();

final class MapEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventModel>>,
          List<EventModel>,
          FutureOr<List<EventModel>>
        >
    with $FutureModifier<List<EventModel>>, $FutureProvider<List<EventModel>> {
  const MapEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<EventModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventModel>> create(Ref ref) {
    return mapEvents(ref);
  }
}

String _$mapEventsHash() => r'8ae32a336c8e5dfd0f8ba1ea97ee16ecce186460';

@ProviderFor(filteredMapPosts)
const filteredMapPostsProvider = FilteredMapPostsProvider._();

final class FilteredMapPostsProvider
    extends
        $FunctionalProvider<List<PostModel>, List<PostModel>, List<PostModel>>
    with $Provider<List<PostModel>> {
  const FilteredMapPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMapPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMapPostsHash();

  @$internal
  @override
  $ProviderElement<List<PostModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PostModel> create(Ref ref) {
    return filteredMapPosts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PostModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PostModel>>(value),
    );
  }
}

String _$filteredMapPostsHash() => r'bdee708e439a014f147119257179d48f7896ae90';

@ProviderFor(filteredMapEvents)
const filteredMapEventsProvider = FilteredMapEventsProvider._();

final class FilteredMapEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  const FilteredMapEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMapEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMapEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return filteredMapEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$filteredMapEventsHash() => r'eb6072e0836913085636ff56da061348d26247d3';

@ProviderFor(MapFilterPanel)
const mapFilterPanelProvider = MapFilterPanelProvider._();

final class MapFilterPanelProvider
    extends $NotifierProvider<MapFilterPanel, bool> {
  const MapFilterPanelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapFilterPanelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapFilterPanelHash();

  @$internal
  @override
  MapFilterPanel create() => MapFilterPanel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mapFilterPanelHash() => r'35b93aa113ad5b97bd5db62192d973c3606b8cf8';

abstract class _$MapFilterPanel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
