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
    final postsAsync = ref.watch(postsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              title: const Text(
                "Bacheca Emergenze",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              actions: [
                if (loggedIn)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ButtonWidget(
                      label: 'Nuovo Post',
                      onPressed: () {
                        context.push('/create-post');
                      },
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
            PostFeed(postsAsync: postsAsync),
          ],
        ),
      ),
    );
  }
}
