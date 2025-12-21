import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/button.dart';
import 'package:greenlinkapp/features/event/widgets/event_feed.dart';

class VolunteeringFeedPage extends ConsumerWidget {
  const VolunteeringFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => ref.read(eventsProvider.notifier).refreshAll(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                      const Expanded(
                        child: Text(
                          "Bacheca Volontariato",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      ButtonWidget(
                        label: 'Nuovo Evento',
                        onPressed: () {
                          // context.push('/create-event');
                        },
                        icon: Icon(Icons.add, color: colorScheme.onSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          EventFeed(eventsAsync: eventsAsync),
        ],
      ),
    );
  }
}
