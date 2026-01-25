import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/button.dart';
import 'package:greenlinkapp/features/event/widgets/event_feed.dart';

class VolunteeringFeedPage extends ConsumerStatefulWidget {
  const VolunteeringFeedPage({super.key});

  @override
  ConsumerState<VolunteeringFeedPage> createState() =>
      _VolunteeringFeedPageState();
}

class _VolunteeringFeedPageState extends ConsumerState<VolunteeringFeedPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(eventsProvider(null).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(sortedEventsProvider);
    final filter = ref.watch(eventFilterProvider);
    final sortCriteria = ref.watch(eventSortCriteriaProvider);
    final isPartner = ref.watch(authProvider).asData?.value.isPartner ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () {
        return ref.refresh(eventsProvider(null).future);
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) =>
                              ref
                                      .read(eventsSearchQueryProvider.notifier)
                                      .state =
                                  val,
                          textInputAction: TextInputAction.done,
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
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.filter_list),
                        onSelected: (String value) {
                          if (value == 'excludeParticipating') {
                            ref
                                .read(eventFilterProvider.notifier)
                                .setExcludeParticipating(
                                  !filter.excludeParticipating,
                                );
                          } else if (value == 'excludeExpired') {
                            ref
                                .read(eventFilterProvider.notifier)
                                .setExcludeExpired(!filter.excludeExpired);
                          } else if (value == 'excludeCreated') {
                            ref
                                .read(eventFilterProvider.notifier)
                                .setExcludeCreated(!filter.excludeCreated);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              CheckedPopupMenuItem<String>(
                                value: 'excludeParticipating',
                                checked: filter.excludeParticipating,
                                child: const Text(
                                  'Nascondi eventi a cui partecipo',
                                ),
                              ),
                              CheckedPopupMenuItem<String>(
                                value: 'excludeExpired',
                                checked: filter.excludeExpired,
                                child: const Text('Nascondi eventi scaduti'),
                              ),
                              if (isPartner) ...[
                                const PopupMenuDivider(),
                                CheckedPopupMenuItem<String>(
                                  value: 'excludeCreated',
                                  checked: filter.excludeCreated,
                                  child: const Text('Nascondi eventi creati'),
                                ),
                              ],
                            ],
                      ),
                    ],
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
                      if (isPartner) ...[
                        ButtonWidget(
                          label: 'Nuovo Evento',
                          onPressed: () {
                            context.push('/create-event');
                          },
                          icon: Icon(Icons.add, color: colorScheme.onSecondary),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<EventSortCriteria>(
                      segments: const [
                        ButtonSegment(
                          value: EventSortCriteria.date,
                          label: Text('Recenti'),
                          icon: Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: EventSortCriteria.proximity,
                          label: Text('Vicini'),
                          icon: Icon(Icons.near_me),
                        ),
                      ],
                      selected: {sortCriteria},
                      onSelectionChanged: (newSelection) {
                        ref
                            .read(eventSortCriteriaProvider.notifier)
                            .setCriteria(newSelection.first);
                      },
                    ),
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
