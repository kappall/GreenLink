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

String _$eventsHash() => r'465f68cc4642e44b9125423f6063c3f19618a39c';

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

@ProviderFor(EventsByUser)
const eventsByUserProvider = EventsByUserFamily._();

final class EventsByUserProvider
    extends $AsyncNotifierProvider<EventsByUser, PaginatedResult<EventModel>> {
  const EventsByUserProvider._({
    required EventsByUserFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'eventsByUserProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventsByUserHash();

  @override
  String toString() {
    return r'eventsByUserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventsByUser create() => EventsByUser();

  @override
  bool operator ==(Object other) {
    return other is EventsByUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventsByUserHash() => r'b60dfbd43c13e10d736548d5c356dba42b10c2fe';

final class EventsByUserFamily extends $Family
    with
        $ClassFamilyOverride<
          EventsByUser,
          AsyncValue<PaginatedResult<EventModel>>,
          PaginatedResult<EventModel>,
          FutureOr<PaginatedResult<EventModel>>,
          int
        > {
  const EventsByUserFamily._()
    : super(
        retry: null,
        name: r'eventsByUserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  EventsByUserProvider call(int userId) =>
      EventsByUserProvider._(argument: userId, from: this);

  @override
  String toString() => r'eventsByUserProvider';
}

abstract class _$EventsByUser
    extends $AsyncNotifier<PaginatedResult<EventModel>> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<PaginatedResult<EventModel>> build(int userId);
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

@ProviderFor(EventsByPartner)
const eventsByPartnerProvider = EventsByPartnerFamily._();

final class EventsByPartnerProvider
    extends
        $AsyncNotifierProvider<EventsByPartner, PaginatedResult<EventModel>> {
  const EventsByPartnerProvider._({
    required EventsByPartnerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'eventsByPartnerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventsByPartnerHash();

  @override
  String toString() {
    return r'eventsByPartnerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventsByPartner create() => EventsByPartner();

  @override
  bool operator ==(Object other) {
    return other is EventsByPartnerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventsByPartnerHash() => r'1e1306272be47916c499aa68f15579c855bd7f83';

final class EventsByPartnerFamily extends $Family
    with
        $ClassFamilyOverride<
          EventsByPartner,
          AsyncValue<PaginatedResult<EventModel>>,
          PaginatedResult<EventModel>,
          FutureOr<PaginatedResult<EventModel>>,
          int
        > {
  const EventsByPartnerFamily._()
    : super(
        retry: null,
        name: r'eventsByPartnerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  EventsByPartnerProvider call(int partnerId) =>
      EventsByPartnerProvider._(argument: partnerId, from: this);

  @override
  String toString() => r'eventsByPartnerProvider';
}

abstract class _$EventsByPartner
    extends $AsyncNotifier<PaginatedResult<EventModel>> {
  late final _$args = ref.$arg as int;
  int get partnerId => _$args;

  FutureOr<PaginatedResult<EventModel>> build(int partnerId);
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

String _$eventsByDistanceHash() => r'2fc95e65d032a4464600d1e5af1361ffdcb7d798';

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
