// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Events)
const eventsProvider = EventsFamily._();

final class EventsProvider
    extends $AsyncNotifierProvider<Events, PaginatedEvents> {
  const EventsProvider._({
    required EventsFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'eventsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventsHash();

  @override
  String toString() {
    return r'eventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Events create() => Events();

  @override
  bool operator ==(Object other) {
    return other is EventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventsHash() => r'e1e9bd68d11591d4ebdb1cdf7aa9a4ce88a440d8';

final class EventsFamily extends $Family
    with
        $ClassFamilyOverride<
          Events,
          AsyncValue<PaginatedEvents>,
          PaginatedEvents,
          FutureOr<PaginatedEvents>,
          int?
        > {
  const EventsFamily._()
    : super(
        retry: null,
        name: r'eventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  EventsProvider call(int? partnerId) =>
      EventsProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'eventsProvider';
}

abstract class _$Events extends $AsyncNotifier<PaginatedEvents> {
  late final _$args = ref.$arg as int?;
  int? get partnerId => _$args;

  FutureOr<PaginatedEvents> build(int? partnerId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<PaginatedEvents>, PaginatedEvents>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaginatedEvents>, PaginatedEvents>,
              AsyncValue<PaginatedEvents>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EventsByDistance)
const eventsByDistanceProvider = EventsByDistanceProvider._();

final class EventsByDistanceProvider
    extends $AsyncNotifierProvider<EventsByDistance, PaginatedEvents> {
  const EventsByDistanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsByDistanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsByDistanceHash();

  @$internal
  @override
  EventsByDistance create() => EventsByDistance();
}

String _$eventsByDistanceHash() => r'98c4349a7bbe88ac5075d0533644244a3427504e';

abstract class _$EventsByDistance extends $AsyncNotifier<PaginatedEvents> {
  FutureOr<PaginatedEvents> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PaginatedEvents>, PaginatedEvents>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaginatedEvents>, PaginatedEvents>,
              AsyncValue<PaginatedEvents>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
        isAutoDispose: true,
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

String _$mapEventsHash() => r'989b30d47d607e0436ee9e932a015cd5c817b4f4';
