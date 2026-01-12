import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/services/event_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../location/providers/location_provider.dart';

part 'event_provider.g.dart';

enum EventSortCriteria { date, proximity }

class PaginatedEvents {
  final List<EventModel> events;
  final int page;
  final bool hasMore;

  PaginatedEvents({this.events = const [], this.page = 1, this.hasMore = true});

  PaginatedEvents copyWith({
    List<EventModel>? events,
    int? page,
    bool? hasMore,
  }) {
    return PaginatedEvents(
      events: events ?? this.events,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class EventFilter {
  final bool excludeParticipating;
  final bool excludeExpired;

  EventFilter({this.excludeParticipating = false, this.excludeExpired = false});

  EventFilter copyWith({bool? excludeParticipating, bool? excludeExpired}) {
    return EventFilter(
      excludeParticipating: excludeParticipating ?? this.excludeParticipating,
      excludeExpired: excludeExpired ?? this.excludeExpired,
    );
  }
}

class EventFilterNotifier extends Notifier<EventFilter> {
  @override
  EventFilter build() => EventFilter();

  void setExcludeParticipating(bool value) {
    state = state.copyWith(excludeParticipating: value);
  }

  void setExcludeExpired(bool value) {
    state = state.copyWith(excludeExpired: value);
  }
}

final eventFilterProvider = NotifierProvider<EventFilterNotifier, EventFilter>(
  EventFilterNotifier.new,
);

class EventSortCriteriaNotifier extends Notifier<EventSortCriteria> {
  @override
  EventSortCriteria build() => EventSortCriteria.date;

  void setCriteria(EventSortCriteria criteria) => state = criteria;

  void reset() {
    state = EventSortCriteria.date;
  }
}

final eventSortCriteriaProvider =
    NotifierProvider<EventSortCriteriaNotifier, EventSortCriteria>(
      EventSortCriteriaNotifier.new,
    );

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

@Riverpod(keepAlive: true)
class Events extends _$Events {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedEvents> build(int? partnerId) async {
    ref.onDispose(() {
      _eventService.clearCache();
    });
    return _fetchPage(1);
  }

  Future<PaginatedEvents> _fetchPage(int page) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final events = await _eventService.fetchAllEvents(
      token: token,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return PaginatedEvents(
      events: events,
      page: page,
      hasMore: events.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !state.value!.hasMore) return;
    _isLoadingMore = true;

    try {
      final nextPage = state.value!.page + 1;
      final newPage = await _fetchPage(nextPage);
      final currentEvents = state.value?.events ?? [];
      final allEvents = [...currentEvents, ...newPage.events];

      state = AsyncValue.data(
        state.value!.copyWith(
          events: allEvents,
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
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
    ref.invalidate(eventsProvider);
  }

  Future<void> participate({required int eventId}) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) return;

    final previousEvents = state.value?.events ?? [];

    final newEvents = previousEvents.map((event) {
      if (event.id == eventId) {
        return event.copyWith(
          isParticipating: true,
          participantsCount: event.participantsCount + 1,
        );
      }
      return event;
    }).toList();

    state = AsyncValue.data(
      state.value!.copyWith(events: newEvents),
    );

    try {
      await _eventService.participate(
        token: authState.token!,
        eventId: eventId,
      );
      _eventService.clearCache();
      ref.invalidate(eventsProvider);
      ref.invalidate(eventsByDistanceProvider);
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(events: previousEvents),
      );
    }
  }
}

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

final eventsByPartnerIdProvider = FutureProvider.family<List<EventModel>, int>((
  ref,
  partnerId,
) async {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token ?? '';
  return EventService.instance.fetchEvents(
    token: token,
    partnerId: partnerId,
  );
});

@Riverpod(keepAlive: true)
class EventsByDistance extends _$EventsByDistance {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedEvents> build() async {
    ref.onDispose(() {
      _eventService.clearCache();
    });
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      data: (userLocation) {
        if (userLocation == null) {
          return PaginatedEvents(hasMore: false);
        }
        return _fetchPage(1, userLocation.latitude, userLocation.longitude);
      },
      loading: () => PaginatedEvents(hasMore: false),
      error: (err, stack) => PaginatedEvents(hasMore: false),
    );
  }

  Future<PaginatedEvents> _fetchPage(int page, double lat, double lng) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final events = await _eventService.fetchEventsByDistance(
      token: token,
      latitude: lat,
      longitude: lng,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return PaginatedEvents(
      events: events,
      page: page,
      hasMore: events.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    final userLocation = ref.read(userLocationProvider).value;
    if (_isLoadingMore || !state.value!.hasMore || userLocation == null) return;
    _isLoadingMore = true;

    try {
      final nextPage = state.value!.page + 1;
      final newPage = await _fetchPage(
        nextPage,
        userLocation.latitude,
        userLocation.longitude,
      );
      final currentEvents = state.value?.events ?? [];
      final allEvents = [...currentEvents, ...newPage.events];
      final uniqueEvents = allEvents.toSet().toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          events: uniqueEvents,
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

final sortedEventsProvider = Provider.autoDispose<AsyncValue<PaginatedEvents>>((
  ref,
) {
  final criteria = ref.watch(eventSortCriteriaProvider);

  final eventsAsync = criteria == EventSortCriteria.proximity
      ? ref.watch(eventsByDistanceProvider)
      : ref.watch(eventsProvider(null));

  final filter = ref.watch(eventFilterProvider);
  final query = ref.watch(eventsSearchQueryProvider).toLowerCase();

  return eventsAsync.whenData((paginated) {
    var filteredEvents = paginated.events;

    if (filter.excludeParticipating) {
      filteredEvents = filteredEvents
          .where((element) => !element.isParticipating)
          .toList();
    }

    if (filter.excludeExpired) {
      filteredEvents = filteredEvents
          .where((element) => element.startDate.isAfter(DateTime.now()))
          .toList();
    }

    if (query.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) {
        final titleMatch = event.title.toLowerCase().contains(query);
        final descriptionMatch = event.description.toLowerCase().contains(
          query,
        );
        return titleMatch || descriptionMatch;
      }).toList();
    }

    return paginated.copyWith(events: filteredEvents);
  });
});

@riverpod
Future<List<EventModel>> mapEvents(Ref ref) async {
  final userLocationAsync = ref.watch(userLocationProvider);

  return userLocationAsync.when(
    data: (userLocation) {
      if (userLocation == null) {
        return [];
      }
      final service = EventService.instance;
      final authState = ref.watch(authProvider);
      final token = authState.asData?.value.token;

      return service.fetchEventsByDistance(
        token: token,
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        limit: 30,
      );
    },
    loading: () => [],
    error: (err, stack) => [],
  );
}
