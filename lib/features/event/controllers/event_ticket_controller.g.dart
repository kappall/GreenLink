// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_ticket_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventTicketController)
const eventTicketControllerProvider = EventTicketControllerFamily._();

final class EventTicketControllerProvider
    extends $NotifierProvider<EventTicketController, EventTicketState> {
  const EventTicketControllerProvider._({
    required EventTicketControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventTicketControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventTicketControllerHash();

  @override
  String toString() {
    return r'eventTicketControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventTicketController create() => EventTicketController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventTicketState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventTicketState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventTicketControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventTicketControllerHash() =>
    r'12ad295cad19f9b9e7a8e9068acfc880a6a026de';

final class EventTicketControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EventTicketController,
          EventTicketState,
          EventTicketState,
          EventTicketState,
          String
        > {
  const EventTicketControllerFamily._()
    : super(
        retry: null,
        name: r'eventTicketControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventTicketControllerProvider call(String eventId) =>
      EventTicketControllerProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventTicketControllerProvider';
}

abstract class _$EventTicketController extends $Notifier<EventTicketState> {
  late final _$args = ref.$arg as String;
  String get eventId => _$args;

  EventTicketState build(String eventId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<EventTicketState, EventTicketState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventTicketState, EventTicketState>,
              EventTicketState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
