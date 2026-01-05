import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/feed/widgets/report_dialog.dart';
import 'package:intl/intl.dart';

import '../../user/providers/user_provider.dart';

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

    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == event.author.id;

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
            if (event.isParticipating && !isAuthor)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: UiBadge(
                  label: "ISCRITTO",
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            const SizedBox(width: 8),
            if (isAuthor)
              const UiBadge(
                label: "Creato da te",
                color: Colors.orange,
                icon: Icons.star,
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
                      event.author.displayName.isNotEmpty == true
                          ? event.author.displayName[0].toUpperCase()
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
                      event.author.displayName,
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
              '${event.participantsCount} / ${event.maxParticipants} Partecipanti',
              style: TextStyle(
                color: event.participantsCount >= event.maxParticipants
                    ? Colors.red
                    : null,
                fontWeight: event.participantsCount >= event.maxParticipants
                    ? FontWeight.bold
                    : null,
              ),
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
          child: FilledButton(onPressed: onTap, child: Text('Dettagli')),
        ),
      ],
    );
  }
}
