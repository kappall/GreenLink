import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/feed/widgets/post_card.dart';

import '../models/post_model.dart';

class PostFeed extends ConsumerWidget {
  final AsyncValue<List<PostModel>> postsAsync;
  const PostFeed({super.key, required this.postsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return postsAsync.when(
      data: (posts) => posts.isEmpty
          ? const SliverFillRemaining(
              child: Center(child: Text("Nessun post da visualizzare.")),
            )
          : SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              sliver: SliverList.separated(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return UiCard(
                    child: PostCard(
                      post: post,
                      onTap: () => context.push('/post-info', extra: post),
                    ),
                    onTap: () => context.push('/post-info', extra: post),
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
    );
  }
}
