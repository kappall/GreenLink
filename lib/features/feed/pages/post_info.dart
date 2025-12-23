import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/widgets/comment_input_field.dart';
import 'package:greenlinkapp/features/user/providers/user_provider.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/badge.dart';
import '../../../core/providers/geocoding_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../widgets/comment_card.dart';

class PostInfoPage extends ConsumerStatefulWidget {
  final PostModel post;

  const PostInfoPage({super.key, required this.post});

  @override
  ConsumerState<PostInfoPage> createState() => _PostInfoPageState();
}

class _PostInfoPageState extends ConsumerState<PostInfoPage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final timestamp = post.createdAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(post.createdAt!.toLocal())
        : '';

    final geoKey = (lat: post.latitude, lng: post.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${post.latitude}, ${post.longitude}";

    final authState = ref.watch(authProvider);
    final isAdmin = authState.asData?.value.isAdmin ?? false;
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == post.author.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dettaglio Post"),
        actions: [
          if (isAdmin || isAuthor)
            IconButton(
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _isDeleting ? null : () => _confirmDelete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    post.author.displayName.isNotEmpty == true
                        ? post.author.displayName[0].toUpperCase()
                        : '?',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                UiBadge(
                  label: post.category.label,
                  icon: post.category.icon,
                  color: post.category.color,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              post.description,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "Posizione",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    locationName,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Recenti"),
                  selected:
                      ref.watch(commentSortProvider) ==
                      CommentSortCriteria.recent,
                  onSelected: (val) =>
                      ref.read(commentSortProvider.notifier).state =
                          CommentSortCriteria.recent,
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Più votati"),
                  selected:
                      ref.watch(commentSortProvider) ==
                      CommentSortCriteria.mostLiked,
                  onSelected: (val) =>
                      ref.read(commentSortProvider.notifier).state =
                          CommentSortCriteria.mostLiked,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ref
                .watch(commentsProvider(post.id!))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text("Errore nel caricamento dei commenti: $err"),
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Nessun commento presente. Sii il primo!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return CommentCard(
                          comment: comment,
                          onLike: () {
                            // Logica like
                          },
                          onReply: () {
                            // Logica risposta
                          },
                          onReport: () {
                            // Logica segnalazione
                          },
                        );
                      },
                    );
                  },
                ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommentInputField(postId: post.id!),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elimina Post"),
        content: const Text("Sei sicuro di voler eliminare questo post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Elimina", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        await ref
            .read(userPostsProvider(null).notifier)
            .deletePost(widget.post.id!);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Errore durante l'eliminazione: $e")),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }
}
