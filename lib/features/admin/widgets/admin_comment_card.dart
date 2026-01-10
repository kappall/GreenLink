import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/card.dart';
import '../../feed/models/comment_model.dart';
import '../../feed/providers/comment_provider.dart';

class AdminCommentCard extends ConsumerWidget {
  final CommentModel comment;

  const AdminCommentCard({super.key, required this.comment});

  Future<void> _confirmDeleteComment(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elimina Commento"),
        content: const Text("Sei sicuro di voler eliminare questo commento?"),
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
      await ref.read(commentsProvider(-1).notifier).deleteComment(comment.id);
      ref.invalidate(commentsByUserIdProvider(comment.author.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timestamp = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(comment.createdAt.toLocal());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return UiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  comment.author.displayName.characters.first.toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID Contenuto: ${comment.contentId}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDeleteComment(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${comment.votesCount} Upvote',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
