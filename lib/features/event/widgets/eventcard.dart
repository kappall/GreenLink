import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/feed/widgets/reportdialog.dart';  
import 'package:greenlinkapp/features/event/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.TITOLO?,
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
              icon: Icons.warning_amber_rounded,
              color: Colors.blue,
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 13, // diametro = radius * 2
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      event.author!.displayName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Flexible(
                    child: Text(
                      event.author!.displayName,
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

        SizedBox(height: 12),

        Text(
          event.description,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text("${event.latitude}, ${event.longitude}"),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.group, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${event.participants} / ${event.maxParticipants} Partecipanti',
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${DateFormat('d MMM yyyy').format(event.startDate)} • ${DateFormat('HH:mm').format(event.startDate)} - ${DateFormat('HH:mm').format(event.endDate)}'
            ),
          ],
        ),
        SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onTap,
              child: const Text('Partecipa'),
            ),
          ),
      ],
    );
  }
}
