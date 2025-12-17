import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/event/widgets/button.dart';
import 'package:greenlinkapp/features/event/widgets/eventcard.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';

class VolunteeringPage extends StatelessWidget {
  const VolunteeringPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Cerca eventi di volontariato...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Bacheca Volontariato",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
              ButtonWidget(
                label: 'Nuovo Evento',
                onPressed: () {
                  // Azione per creare un nuovo evento di volontariato
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
          ],
        ),

        const SizedBox(height: 8),

        for (final e in events)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: UiCard(
              child: EventCard(
                event: e,
                onTap: () => context.push('/event-info', extra: e),
              ),
            ),
          ),
      ],
    );
  }
}
