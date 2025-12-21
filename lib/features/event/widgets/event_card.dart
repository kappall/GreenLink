import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/feed/widgets/reportdialog.dart';
import 'package:intl/intl.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geoKey = (lat: event.latitude, lng: event.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${event.latitude}, ${event.longitude}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.description.split('\n').first,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            UiBadge(
              label: event.eventType.name,
              icon: Icons.event,
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      event.author?.displayName.isNotEmpty == true
                          ? event.author!.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      event.author?.displayName ?? 'Utente Anonimo',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                showReportDialog(context, item: event);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.flag_outlined,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(event.description, maxLines: 4, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                locationName,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.group, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${event.votes_count} / ${event.maxParticipants} Partecipanti', //TODO: change with participants
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${DateFormat('d MMM yyyy').format(event.startDate)} • ${DateFormat('HH:mm').format(event.startDate)} - ${DateFormat('HH:mm').format(event.endDate)}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onTap, child: const Text('Dettagli')),
        ),
      ],
    );
  }
}
