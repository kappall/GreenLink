import 'package:greenlinkapp/core/common/handle_api_error.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/services/event_service.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/services/post_service.dart';
import 'package:greenlinkapp/features/location/providers/location_provider.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_provider.g.dart';

class MapFilter {
  final bool showPosts;
  final bool showEvents;

  const MapFilter({this.showPosts = true, this.showEvents = true});

  MapFilter copyWith({bool? showPosts, bool? showEvents}) {
    return MapFilter(
      showPosts: showPosts ?? this.showPosts,
      showEvents: showEvents ?? this.showEvents,
    );
  }
}

@riverpod
class MapFilterState extends _$MapFilterState {
  @override
  MapFilter build() => const MapFilter();

  void togglePosts() {
    state = state.copyWith(showPosts: !state.showPosts);
  }

  void toggleEvents() {
    state = state.copyWith(showEvents: !state.showEvents);
  }

  void reset() {
    state = const MapFilter();
  }
}

@Riverpod(keepAlive: true)
Future<List<PostModel>> mapPosts(Ref ref) async {
  final userLocationAsync = ref.watch(userLocationProvider);

  return userLocationAsync.when(
    data: (userLocation) async {
      if (userLocation == null) {
        return [];
      }
      final service = PostService.instance;
      final authState = ref.watch(authProvider);
      final token = authState.asData?.value.token;

      try {
        return (await service.fetchPostsByDistance(
          token: token,
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          limit: 100,
        )).items;
      } on Response catch (e) {
        await handleError(e, ref);
        return [];
      } catch (e) {
        FeedbackUtils.logError(e);
        return [];
      }
    },
    loading: () => [],
    error: (err, stack) {
      FeedbackUtils.logError(err);
      return [];
    },
  );
}

@Riverpod(keepAlive: true)
Future<List<EventModel>> mapEvents(Ref ref) async {
  final userLocationAsync = ref.watch(userLocationProvider);

  return userLocationAsync.when(
    data: (userLocation) async {
      if (userLocation == null) {
        return [];
      }
      final service = EventService.instance;
      final authState = ref.watch(authProvider);
      final token = authState.asData?.value.token;

      try {
        return (await service.fetchEventsByDistance(
          token: token,
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          limit: 100,
        )).items.where((e) => e.startDate.isAfter(DateTime.now())).toList();
      } on Response catch (e) {
        await handleError(e, ref);
        return [];
      } catch (e) {
        FeedbackUtils.logError(e);
        return [];
      }
    },
    loading: () => [],
    error: (err, stack) {
      FeedbackUtils.logError(err);
      return [];
    },
  );
}

@riverpod
List<PostModel> filteredMapPosts(Ref ref) {
  final filter = ref.watch(mapFilterStateProvider);
  final posts = ref.watch(mapPostsProvider).value ?? [];

  if (!filter.showPosts) return const [];
  return posts;
}

@riverpod
List<EventModel> filteredMapEvents(Ref ref) {
  final filter = ref.watch(mapFilterStateProvider);
  final events = ref.watch(mapEventsProvider).value ?? [];

  if (!filter.showEvents) return const [];
  return events;
}

@riverpod
class MapFilterPanel extends _$MapFilterPanel {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
