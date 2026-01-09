import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/services/event_service.dart';

class EventsNotifier extends AsyncNotifier<List<EventModel>> {
  final EventService _eventService = EventService.instance;
  int? _partnerId;

  @override
  Future<List<EventModel>> build() async {
    return _fetchEvents(partnerId: _partnerId);
  }

  Future<void> refresh({int? partnerId}) async {
    if (partnerId != null) {
      _partnerId = partnerId;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchEvents(partnerId: _partnerId));
  }

  Future<void> refreshAll() async {
    _partnerId = null;

    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchEvents);
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
    required int maxParticipants,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final authState = ref.read(authProvider).asData?.value;
    final token = authState?.token;

    if (token == null || token.isEmpty) {
      throw Exception('Utente non autenticato');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _eventService.createEvent(
        token: token,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        eventType: eventType,
        maxParticipants: maxParticipants,
        startDate: startDate,
        endDate: endDate,
      );
      return _fetchEvents(partnerId: _partnerId);
    });
  }

  Future<List<EventModel>> _fetchEvents({int? partnerId}) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (partnerId != null && partnerId > 0) {
      return _eventService.fetchEvents(token: token!, partnerId: partnerId);
    }

    return _eventService.fetchAllEvents(token: token);
  }

  Future<void> participate({required int eventId}) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;

    if (token == null || token.isEmpty) {
      throw Exception('Utente non autenticato');
    }

    return _eventService.participate(token: token, eventId: eventId);
  }
}

final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<EventModel>>(
  () {
    return EventsNotifier();
  },
);

final eventsByUserIdProvider = FutureProvider.family<List<EventModel>, int>((
  ref,
  userId,
) async {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;
  return EventService.instance.fetchEventsByUserId(
    token: token,
    userId: userId,
  );
});

class EventsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  @override
  set state(String value) => super.state = value;
}

final eventsSearchQueryProvider =
    NotifierProvider<EventsSearchQueryNotifier, String>(
      EventsSearchQueryNotifier.new,
    );

final filteredEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final eventsAsync = ref.watch(eventsProvider);
  final query = ref.watch(eventsSearchQueryProvider).toLowerCase();

  final events = eventsAsync.value ?? [];

  if (query.isEmpty) {
    return events;
  }

  // Se la query non è vuota provo a risolvere la città
  String? targetCity;
  try {
    final locations = await geo.locationFromAddress(query);
    if (locations.isNotEmpty) {
      final placemarks = await geo.placemarkFromCoordinates(
        locations.first.latitude,
        locations.first.longitude,
      );
      if (placemarks.isNotEmpty) {
        targetCity = placemarks.first.locality?.toLowerCase();
      }
    }
  } catch (_) {
    targetCity = null;
  }

  // Se abbiamo trovato una città confronto le città degli eventi
  if (targetCity != null) {
    final filtered = <EventModel>[];
    for (final e in events) {
      try {
        final placemarks = await geo.placemarkFromCoordinates(
          e.latitude,
          e.longitude,
        );
        if (placemarks.isNotEmpty) {
          final eventCity = placemarks
              .where((p) => p.locality != null)
              .map((p) => p.locality!.toLowerCase());
          if (eventCity.contains(targetCity)) {
            filtered.add(e);
            continue;
          }
        }
      } catch (_) {}

      if (e.description.toLowerCase().contains(query)) {
        filtered.add(e);
      }
    }
    return filtered;
  }

  return events
      .where((e) => e.description.toLowerCase().contains(query))
      .toList();
});
