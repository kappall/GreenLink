//temporaneo, da usare gli stessi del feed

import 'package:flutter/material.dart';

import '../../../core/common/widgets/ui.dart';
import '../../../data/tmp.dart';

class VolunteerCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onRemove;

  const VolunteerCard({super.key, required this.event, this.onRemove});

  @override
  Widget build(BuildContext context) {
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
                    UiBadge(
                      label: event.category.label,
                      color: event.category.color,
                      icon: event.category.icon,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
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
                event.organizer.name,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Grid
          Row(
            children: [
              _buildInfoIcon(
                Icons.calendar_today,
                "${event.date}, ${event.time}",
              ),
              const SizedBox(width: 16),
              _buildInfoIcon(Icons.location_on, event.location),
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
