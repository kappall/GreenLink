import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/button.dart';
import 'package:greenlinkapp/features/event/widgets/event_card.dart';

class VolunteeringFeedPage extends ConsumerWidget {
  const VolunteeringFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Cerca eventi di volontariato...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: colorScheme.secondaryContainer,
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
              icon: Icon(Icons.add, color: colorScheme.onSecondary),
            ),
          ],
        ),

        const SizedBox(height: 8),

        eventsAsync.when(
          data: (events) => Column(
            children: [
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
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Errore nel caricamento degli eventi: $error',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
