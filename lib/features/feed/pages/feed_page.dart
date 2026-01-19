import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/feed/widgets/filterdialog.dart';
import 'package:greenlinkapp/features/feed/widgets/post_feed.dart';
import 'package:greenlinkapp/features/feed/widgets/sortdropdown.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/post_provider.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
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
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(postsProvider(null).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider).value;

    ref.listen(sortedPostsProvider, (_, state) {
      if (state.isLoading || state.isRefreshing || state.hasError) return;

      final paginated = state.value;
      if (paginated == null) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent == 0 &&
            paginated.hasMore) {
          ref.read(postsProvider(null).notifier).loadMore();
        }
      });
    });

    final postsAsync = ref.watch(sortedPostsProvider);
    final criteria = ref.watch(postSortCriteriaProvider);
    final filter = ref.watch(postFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(postsProvider(null).future),
        child: CustomScrollView(
          controller: _scrollController,
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
                      onPressed: () => showFilterDialog(
                        context,
                        ref,
                        filter,
                        ref.read(postsProvider(null).notifier).loadMore,
                      ),
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
            PostFeed(postPageAsync: postsAsync),
            SliverToBoxAdapter(
              child: postsAsync.maybeWhen(
                data: (paginated) => paginated.hasMore
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
