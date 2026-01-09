import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../feed/models/comment_model.dart';
import '../../feed/providers/comment_provider.dart';
import '../../user/providers/user_provider.dart';

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
      await ref
          .read(commentsProvider(-1).notifier)
          .deleteComment(comment.id); // non serve postId per eliminare commento
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      timestamp,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${comment.votesCount} votes',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
                    if (isAuthor || isAdmin)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 24,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDeleteComment(context, ref),
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
