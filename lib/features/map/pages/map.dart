import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final LatLng _initialCenter = const LatLng(45.4398, 12.3319);
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (posts) => eventsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (events) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: 12.0,
                minZoom: 10.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.greenlink.app',
                ),
                MarkerLayer(
                  markers: [
                    ...posts.map((post) => _buildPostMarker(context, post)),
                    ...events.map((event) => _buildEventMarker(context, event)),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Semantics(
                      label: "Ricentra la mappa sulla posizione iniziale",
                      button: true,
                      child: SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: FloatingActionButton(
                          heroTag: "recenter",
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          onPressed: () {
                            _mapController.move(_initialCenter, 12.0);
                          },
                          child: const Icon(Icons.my_location, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Marker _buildPostMarker(BuildContext context, PostModel post) {
    return Marker(
      point: LatLng(post.latitude, post.longitude),
      width: 40,
      height: 40,
      child: Semantics(
        label: "Segnalazione di  ?? 'utente', categoria ${post.category.label}",
        button: true,
        enabled: true,
        child: GestureDetector(
          onTap: () => _showSummarySheet(context, post: post),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: post.category.color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              post.category.icon,
              color: post.category.color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Marker _buildEventMarker(BuildContext context, EventModel event) {
    return Marker(
      point: LatLng(event.latitude, event.longitude),
      width: 45,
      height: 45,
      child: Semantics(
        label:
            "Evento ${event.eventType.label}, ${event.description.split('\n').first}",
        button: true,
        enabled: true,
        child: GestureDetector(
          onTap: () => _showSummarySheet(context, event: event),
          child: Container(
            decoration: BoxDecoration(
              color: event.eventType.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(event.eventType.icon, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }

  void _showSummarySheet(
    BuildContext context, {
    PostModel? post,
    EventModel? event,
  }) {
    final isPost = post != null;
    final color = isPost ? post.category.color : event!.eventType.color;
    final title = isPost
        ? 'Segnalazione'
        : event!.description.split('\n').first;
    final description = isPost ? post.description : event!.description;

    final geoKey = isPost
        ? (lat: post.latitude, lng: post.longitude)
        : (lat: event!.latitude, lng: event.longitude);
    final location = ref.watch(placeNameProvider(geoKey)).value;
    final icon = isPost ? post.category.icon : event!.eventType.icon;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPost ? "Segnalazione" : "Evento Volontariato",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      location ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Semantics(
                    label: "Apri la pagina di dettaglio",
                    button: true,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: color),
                        onPressed: () {
                          Navigator.pop(ctx);

                          if (isPost) {
                            context.go('/post-info', extra: post);
                          } else {
                            context.go('/event-details', extra: event);
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Vedi Dettagli"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
