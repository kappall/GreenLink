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
    extends $AsyncNotifierProvider<Events, PaginatedResult<EventModel>> {
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

String _$eventsHash() => r'a139547099d9165dc95353773f00c0f430afbda1';

final class EventsFamily extends $Family
    with
        $ClassFamilyOverride<
          Events,
          AsyncValue<PaginatedResult<EventModel>>,
          PaginatedResult<EventModel>,
          FutureOr<PaginatedResult<EventModel>>,
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

abstract class _$Events extends $AsyncNotifier<PaginatedResult<EventModel>> {
  late final _$args = ref.$arg as int?;
  int? get partnerId => _$args;

  FutureOr<PaginatedResult<EventModel>> build(int? partnerId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<EventModel>>,
              PaginatedResult<EventModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<EventModel>>,
                PaginatedResult<EventModel>
              >,
              AsyncValue<PaginatedResult<EventModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EventsByDistance)
const eventsByDistanceProvider = EventsByDistanceProvider._();

final class EventsByDistanceProvider
    extends
        $AsyncNotifierProvider<EventsByDistance, PaginatedResult<EventModel>> {
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

String _$eventsByDistanceHash() => r'ed30f7870d36112eb67c42db2a578a704cc212e9';

abstract class _$EventsByDistance
    extends $AsyncNotifier<PaginatedResult<EventModel>> {
  FutureOr<PaginatedResult<EventModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<EventModel>>,
              PaginatedResult<EventModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<EventModel>>,
                PaginatedResult<EventModel>
              >,
              AsyncValue<PaginatedResult<EventModel>>,
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

String _$mapEventsHash() => r'a609dc0ae79ada562dd83562d992c9094609a4e1';
