import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/services/event_service.dart';

class EventsNotifier extends AsyncNotifier<List<EventModel>> {
  final EventService _eventService = EventService();
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

  Future<List<EventModel>> _fetchEvents({int? partnerId}) async {
    final authState = ref.watch(authProvider);
    final token = authState.asData?.value.token;

    if (partnerId != null && partnerId > 0) {
      return _eventService.fetchEvents(token: token!, partnerId: partnerId);
    }

    return _eventService.fetchAllEvents(token: token);
  }
}

final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<EventModel>>(
  () {
    return EventsNotifier();
  },
);
