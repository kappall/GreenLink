import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/post_card.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';

import '../../auth/providers/auth_provider.dart';
import '../../post/providers/post_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final loggedIn = authState.asData?.value.isAuthenticated ?? false;
    final postsAsync = ref.watch(postsProvider);

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
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
            ),
            postsAsync.when(
              data: (posts) => posts.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text("Nessun post da visualizzare."),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList.separated(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return UiCard(
                            child: PostCard(
                              post: post,
                              onTap: () =>
                                  context.push('/post-info', extra: post),
                            ),
                            onTap: () =>
                                context.push('/post-info', extra: post),
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
                child: Center(child: Text("Errore nel caricamento: $error")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
