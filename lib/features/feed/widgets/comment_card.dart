import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../user/providers/user_provider.dart';
import '../models/comment_model.dart';
import '../providers/comment_provider.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel comment;
  final int postId;
  final VoidCallback? onReply;
  final VoidCallback? onReport;

  const CommentCard({
    super.key,
    required this.comment,
    required this.postId,
    this.onReply,
    this.onReport,
  });

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
      await ref
          .read(commentsProvider(postId).notifier)
          .deleteComment(comment.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timestamp = DateFormat(
      'dd MMM, HH:mm',
    ).format(comment.createdAt.toLocal());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentUser = ref.watch(currentUserProvider).value;
    final isAdmin = ref.watch(authProvider).value?.isAdmin ?? false;
    final isAuthor = currentUser?.id == comment.author.id;

    return UiCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              comment.author.displayName.characters.first.toUpperCase(),
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.author.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ref
                            .read(commentsProvider(postId).notifier)
                            .voteComment(comment.id, comment.hasVoted);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              comment.hasVoted
                                  ? Icons.thumb_up_rounded
                                  : Icons.thumb_up_outlined,
                              size: 18,
                              color: comment.hasVoted
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${comment.votesCount}',
                              style: TextStyle(
                                color: comment.hasVoted
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary,
                                fontWeight: comment.hasVoted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                      
                    const Spacer(),
                    if (isAuthor || isAdmin)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDeleteComment(context, ref),
                      ),
                    IconButton(
                      onPressed: onReport,
                      icon: Icon(
                        Icons.flag_outlined,
                        size: 18,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
