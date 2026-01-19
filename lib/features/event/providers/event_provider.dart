import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/services/event_service.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/feedback_utils.dart';
import '../../location/providers/location_provider.dart';

part 'event_provider.g.dart';

enum EventSortCriteria { date, proximity }

class EventFilter {
  final bool excludeParticipating;
  final bool excludeExpired;
  final bool excludeCreated;

  EventFilter({
    this.excludeParticipating = false,
    this.excludeExpired = false,
    this.excludeCreated = false,
  });

  EventFilter copyWith({
    bool? excludeParticipating,
    bool? excludeExpired,
    bool? excludeCreated,
  }) {
    return EventFilter(
      excludeParticipating: excludeParticipating ?? this.excludeParticipating,
      excludeExpired: excludeExpired ?? this.excludeExpired,
      excludeCreated: excludeCreated ?? this.excludeCreated,
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

  void setExcludeCreated(bool value) {
    state = state.copyWith(excludeCreated: value);
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
}

final eventsSearchQueryProvider =
    NotifierProvider<EventsSearchQueryNotifier, String>(
      EventsSearchQueryNotifier.new,
    );

final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final authState = ref.watch(authProvider).value;
  final userId = authState?.user?.id;
  final isPartner = authState?.isPartner ?? false;

  if (userId == null) {
    return [];
  }

  final participatingEvents =
      ref.watch(eventsByUserProvider(userId)).asData?.value.items ?? [];

  final authoredEvents = isPartner
      ? ref.watch(eventsByPartnerProvider(userId)).asData?.value.items ?? []
      : <EventModel>[];

  final allEvents = {...participatingEvents, ...authoredEvents};

  final now = DateTime.now();
  return allEvents
      .where(
        (event) =>
            event.startDate.year == now.year &&
            event.startDate.month == now.month &&
            event.startDate.day == now.day,
      )
      .toList();
});

@Riverpod(keepAlive: true)
class Events extends _$Events {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<EventModel>> build(int? partnerId) async {
    return _fetchPage(1);
  }

  Future<PaginatedResult<EventModel>> _fetchPage(int page) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final paginatedResult = await _eventService.fetchAllEvents(
      token: token,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return paginatedResult.copyWith(
      page: page,
      hasMore:
          paginatedResult.items.isNotEmpty &&
          paginatedResult.items.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !state.value!.hasMore) return;
    _isLoadingMore = true;

    try {
      final nextPage = state.value!.page + 1;
      final newPage = await _fetchPage(nextPage);
      final currentEvents = state.value?.items ?? [];
      final allEvents = [...currentEvents, ...newPage.items];

      state = AsyncValue.data(
        state.value!.copyWith(
          items: allEvents,
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
    ref.invalidate(eventsByPartnerProvider);
    ref.invalidate(eventsByDistanceProvider);
  }

  Future<void> deleteEvent(int eventId) async {
    final authState = ref.read(authProvider).asData?.value;
    final token = authState?.token;

    try {
      await _eventService.deleteEvent(token: token!, eventId: eventId);
      ref.invalidate(eventsProvider);
      ref.invalidate(eventsByPartnerProvider);
      ref.invalidate(eventsByDistanceProvider);
    } catch (e) {
      FeedbackUtils.logError("Exception in deleteEvent: $e");
      rethrow;
    }
  }

  Future<String> participate({required int eventId}) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final ticket = await _eventService.participate(
        token: authState.token!,
        eventId: eventId,
      );
      ref.invalidate(eventsProvider);
      ref.invalidate(eventsByDistanceProvider);
      ref.invalidate(eventsByUserProvider(authState.user!.id));
      return ticket;
    } catch (e) {
      FeedbackUtils.logError("Exception in participate: $e");
      rethrow;
    }
  }

  Future<void> cancelParticipation({required int eventId}) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _eventService.cancelParticipation(
        token: authState.token!,
        eventId: eventId,
      );
      ref.invalidate(eventsProvider);
      ref.invalidate(eventsByDistanceProvider);
      ref.invalidate(eventsByUserProvider(authState.user!.id));
    } catch (e) {
      FeedbackUtils.logError("Exception in cancelParticipation: $e");
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
class EventsByUser extends _$EventsByUser {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<EventModel>> build(int userId) async {
    return _fetchPage(1, userId);
  }

  Future<PaginatedResult<EventModel>> _fetchPage(int page, int userId) async {
    try {
      final token = ref.watch(authProvider).asData?.value.token;

      final paginatedResult = await _eventService.fetchEventsByUserId(
        token: token,
        userId: userId,
        skip: (page - 1) * _pageSize,
        limit: _pageSize,
      );

      return paginatedResult.copyWith(
        page: page,
        hasMore: paginatedResult.items.length == _pageSize,
      );
    } catch (e, st) {
      FeedbackUtils.logError(e);
      rethrow;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (_isLoadingMore || current == null || !current.hasMore) return;

    _isLoadingMore = true;
    try {
      final nextPage = current.page + 1;
      final next = await _fetchPage(nextPage, userId);

      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...next.items].toSet().toList(),
          page: nextPage,
          hasMore: next.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

@Riverpod(keepAlive: true)
class EventsByPartner extends _$EventsByPartner {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<EventModel>> build(int partnerId) async {
    return _fetchPage(1, partnerId);
  }

  Future<PaginatedResult<EventModel>> _fetchPage(
    int page,
    int partnerId,
  ) async {
    try {
      final token = ref.watch(authProvider).asData?.value.token;

      final paginatedResult = await _eventService.fetchEvents(
        token: token!,
        partnerId: partnerId,
        skip: (page - 1) * _pageSize,
        limit: _pageSize,
      );

      return paginatedResult.copyWith(
        page: page,
        hasMore: paginatedResult.items.length == _pageSize,
      );
    } catch (e, st) {
      FeedbackUtils.logError(e);
      throw e;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (_isLoadingMore || current == null || !current.hasMore) return;

    _isLoadingMore = true;
    try {
      final nextPage = current.page + 1;
      final next = await _fetchPage(nextPage, partnerId);

      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...next.items].toSet().toList(),
          page: nextPage,
          hasMore: next.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

final eventParticipantsProvider = FutureProvider.family<List<UserModel>, int>((
  ref,
  eventId,
) async {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;
  return EventService.instance.fetchEventParticipants(
    token: token,
    eventId: eventId,
  );
});

@Riverpod(keepAlive: true)
class EventsByDistance extends _$EventsByDistance {
  final _eventService = EventService.instance;
  static const _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  FutureOr<PaginatedResult<EventModel>> build() async {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      data: (userLocation) {
        if (userLocation == null) {
          return PaginatedResult<EventModel>(hasMore: false);
        }
        return _fetchPage(1, userLocation.latitude, userLocation.longitude);
      },
      loading: () => PaginatedResult<EventModel>(hasMore: false),
      error: (err, stack) => PaginatedResult<EventModel>(hasMore: false),
    );
  }

  Future<PaginatedResult<EventModel>> _fetchPage(
    int page,
    double lat,
    double lng,
  ) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    final paginatedResult = await _eventService.fetchEventsByDistance(
      token: token,
      latitude: lat,
      longitude: lng,
      skip: (page - 1) * _pageSize,
      limit: _pageSize,
    );

    return paginatedResult.copyWith(
      page: page,
      hasMore:
          paginatedResult.items.isNotEmpty &&
          paginatedResult.items.length == _pageSize,
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
      final currentEvents = state.value?.items ?? [];
      final allEvents = [...currentEvents, ...newPage.items];
      final uniqueEvents = allEvents.toSet().toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          items: uniqueEvents,
          page: nextPage,
          hasMore: newPage.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

final sortedEventsProvider =
    Provider.autoDispose<AsyncValue<PaginatedResult<EventModel>>>((ref) {
      final criteria = ref.watch(eventSortCriteriaProvider);
      final eventsAsync = ref.watch(eventsProvider(null));
      final filter = ref.watch(eventFilterProvider);
      final query = ref.watch(eventsSearchQueryProvider).toLowerCase();
      final location = ref.watch(userLocationProvider).value;

      final isPartner =
          ref.watch(authProvider).asData?.value.isPartner ?? false;
      final partnerId = ref.watch(authProvider).asData?.value.user?.id;

      return eventsAsync.whenData((paginated) {
        var filteredEvents = paginated.items;
        final now = DateTime.now();

        if (filter.excludeParticipating) {
          filteredEvents = filteredEvents
              .where((element) => !element.isParticipating)
              .toList();
        }

        if (filter.excludeExpired) {
          filteredEvents = filteredEvents
              .where((element) => element.startDate.isAfter(now))
              .toList();
        }

        if (isPartner && filter.excludeCreated) {
          FeedbackUtils.logInfo("Partner: $partnerId");
          filteredEvents = filteredEvents
              .where((element) => element.author.id != partnerId)
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

        if (criteria == EventSortCriteria.proximity && location != null) {
          final originLat = location.latitude;
          final originLng = location.longitude;
          filteredEvents = [...filteredEvents]
            ..sort((a, b) {
              final aDist = _distanceInMeters(
                originLat,
                originLng,
                a.latitude,
                a.longitude,
              );
              final bDist = _distanceInMeters(
                originLat,
                originLng,
                b.latitude,
                b.longitude,
              );
              return aDist.compareTo(bDist);
            });
        } else if (criteria == EventSortCriteria.date) {
          filteredEvents = [...filteredEvents]
            ..sort((a, b) {
              final aCreated = a.createdAt ?? a.startDate;
              final bCreated = b.createdAt ?? b.startDate;
              return bCreated.compareTo(aCreated);
            });
        }

        return paginated.copyWith(items: filteredEvents);
      });
    });

double _distanceInMeters(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadius = 6371000.0;
  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);
  final a =
      pow(sin(dLat / 2), 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          pow(sin(dLon / 2), 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _degToRad(double deg) => deg * (pi / 180.0);
