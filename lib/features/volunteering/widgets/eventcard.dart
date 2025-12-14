import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';
import 'package:greenlinkapp/features/feed/widgets/reportdialog.dart';  

class EventCard extends StatelessWidget {
  final Event event;
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
                event.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            UiBadge(
              label: event.eventType,
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
                      event.owner.isNotEmpty ? event.owner[0] : '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Flexible(
                    child: Text(
                      event.owner,
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
            Text(event.location),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.group, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${event.participantsCurrent} / ${event.participantsMax} Partecipanti',
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${event.date} | ${event.startTime} - ${event.endTime}'),
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
