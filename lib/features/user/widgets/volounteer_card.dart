import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/card.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;
  final VoidCallback? onRemove;

  const EventCard({super.key, required this.event, this.onRemove});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = event.description.split('\n').first;
    final date = DateFormat('dd MMM yyyy').format(event.startDate);
    final time = DateFormat('HH:mm').format(event.startDate);

    return UiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Organizer
          Row(
            children: [
              const CircleAvatar(
                radius: 10,
                child: Icon(Icons.person, size: 12),
              ),
              const SizedBox(width: 6),
              Text(
                event.author?.displayName ?? 'Utente Sconosciuto',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Grid
          Row(
            children: [
              _buildInfoIcon(Icons.calendar_today, "$date, $time"),
              const SizedBox(width: 16),
              _buildInfoIcon(
                Icons.location_on,
                '${event.latitude}, ${event.longitude}',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.check, color: Colors.green),
              label: const Text(
                "Iscritto",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
