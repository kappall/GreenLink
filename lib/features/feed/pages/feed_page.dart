import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/feed/widgets/post_feed.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/post_provider.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final loggedIn = authState.asData?.value.isAuthenticated ?? false;
    final postsAsync = ref.watch(sortedPostsProvider);
    final criteria = ref.watch(postSortCriteriaProvider);
    final filter = ref.watch(postFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text(
                "Bacheca Emergenze",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              actions: [
                if (loggedIn)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ButtonWidget(
                      label: 'Nuovo Post',
                      onPressed: () => context.push('/create-post'),
                      icon: Icon(
                        Icons.add,
                        color: colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                  ),
              ],
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context, ref, filter),
                    ),
                    const Spacer(),
                    _buildSortDropdown(ref, criteria),
                  ],
                ),
              ),
            ),
            PostFeed(postsAsync: postsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown(WidgetRef ref, PostSortCriteria criteria) {
    return DropdownButton<PostSortCriteria>(
      value: criteria,
      underline: const SizedBox(),
      icon: const Icon(Icons.sort),
      items: const [
        DropdownMenuItem(value: PostSortCriteria.date, child: Text("Data")),
        DropdownMenuItem(value: PostSortCriteria.votes, child: Text("Voti")),
        DropdownMenuItem(
          value: PostSortCriteria.proximity,
          child: Text("Vicinanza"),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(postSortCriteriaProvider.notifier).setCriteria(value);
        }
      },
    );
  }

  void _showFilterDialog(
    BuildContext context,
    WidgetRef ref,
    PostFilter currentFilter,
  ) {
    final votesController = TextEditingController(
      text: currentFilter.minVotes.toString(),
    );
    final locationController = TextEditingController(
      text: currentFilter.locationQuery,
    );
    DateTime? selectedDate = currentFilter.startDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Filtra Post"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: votesController,
                      decoration: const InputDecoration(
                        labelText: "Voti minimi",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "Posizione (es. Milano)",
                        hintText: "Inserisci città per la vicinanza",
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text("Dal giorno: "),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                          child: Text(
                            selectedDate == null
                                ? "Seleziona"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ),
                        if (selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () =>
                                setState(() => selectedDate = null),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annulla"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(postFilterProvider.notifier)
                        .updateFilter(
                          minVotes: int.tryParse(votesController.text) ?? 0,
                          locationQuery: locationController.text,
                          startDate: selectedDate,
                          clearDate: selectedDate == null,
                        );
                    Navigator.pop(context);
                  },
                  child: const Text("Applica"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
