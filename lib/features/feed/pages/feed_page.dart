import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/feed/widgets/filterdialog.dart';
import 'package:greenlinkapp/features/feed/widgets/post_feed.dart';
import 'package:greenlinkapp/features/feed/widgets/sortdropdown.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/post_provider.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    final postsAsync = ref.watch(sortedPostsProvider);
    final criteria = ref.watch(postSortCriteriaProvider);
    final filter = ref.watch(postFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider(null).notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bacheca Emergenze",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (authState?.isAuthenticated ?? false)
                    ButtonWidget(
                      label: 'Nuovo Post',
                      onPressed: () => context.push('/create-post'),
                      icon: Icon(
                        Icons.add,
                        color: colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                ],
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => showFilterDialog(context, ref, filter),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(postFilterProvider.notifier).reset();
                        ref.read(postSortCriteriaProvider.notifier).reset();
                      },
                      child: const Text("Ripristina"),
                    ),
                    const Spacer(),
                    buildSortDropdown(ref, criteria),
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
}
