import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/feedback_utils.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final LatLng _fallbackCenter = const LatLng(45.4398, 12.3319); // Venezia
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          12.0,
        );
      }
    } catch (_) {
      // In caso di errore restiamo dove siamo
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider(null));
    final eventsAsync = ref.watch(eventsProvider);

    final posts = postsAsync.value?.posts ?? [];
    final events = eventsAsync.value ?? [];

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _fallbackCenter,
              initialZoom: 12.0,
              minZoom: 3.0,
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
            ],
          ),
          // Indicatore di caricamento dati discreto
          if (postsAsync.isLoading || eventsAsync.isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Caricamento segnalazioni...",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Pulsante Recenter
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: "recenter",
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  try {
                    final position = await Geolocator.getCurrentPosition();
                    _mapController.move(
                      LatLng(position.latitude, position.longitude),
                      12.0,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      FeedbackUtils.showSuccess(
                        context,
                        "Impossibile recuperare la posizione",
                      );
                    }
                  }
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildPostMarker(BuildContext context, PostModel post) {
    return Marker(
      point: LatLng(post.latitude, post.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showSummarySheet(context, post: post),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Icon(post.category.icon, color: post.category.color, size: 24),
        ),
      ),
    );
  }

  Marker _buildEventMarker(BuildContext context, EventModel event) {
    return Marker(
      point: LatLng(event.latitude, event.longitude),
      width: 45,
      height: 45,
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
        ? "Segnalazione"
        : event!.description.split('\n').first;
    final description = isPost ? post.description : event!.description;
    final icon = isPost ? post.category.icon : event!.eventType.icon;

    final geoKey = isPost
        ? (lat: post.latitude, lng: post.longitude)
        : (lat: event!.latitude, lng: event.longitude);
    final location = ref.watch(placeNameProvider(geoKey)).value;

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
                      location ?? 'Caricamento posizione...',
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
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: color),
                    onPressed: () {
                      Navigator.pop(ctx);
                      if (isPost) {
                        context.push('/post-info', extra: post);
                      } else {
                        context.push('/event-info', extra: event);
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Vedi Dettagli"),
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
