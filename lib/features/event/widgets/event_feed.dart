import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/paginated_result.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';

import 'event_card.dart';

class EventFeed extends ConsumerWidget {
  final AsyncValue<PaginatedResult<EventModel>> eventsAsync;
  const EventFeed({super.key, required this.eventsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return eventsAsync.when(
      data: (page) => page.items.isEmpty
          ? const SliverFillRemaining(
              child: Center(child: Text("Nessun evento da visualizzare.")),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList.separated(
                itemCount: page.items.length,
                itemBuilder: (context, index) {
                  final event = page.items[index];
                  return UiCard(
                    child: EventCard(event: event),
                    onTap: () => context.push('/event-info', extra: event),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              ),
            ),
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => SliverFillRemaining(
        child: Center(child: Text("Errore nel caricamento Eventi")),
      ),
    );
  }
}
