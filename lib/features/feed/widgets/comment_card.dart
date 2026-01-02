import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/card.dart';
import '../models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onReport;

  const CommentCard({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = DateFormat(
      'dd MMM, HH:mm',
    ).format(comment.createdAt.toLocal());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    _CommentActionButton(
                      icon: comment.hasVoted
                          ? Icons.thumb_up_rounded
                          : Icons.thumb_up_outlined,
                      label: comment.votesCount.toString(),
                      isActive: comment.hasVoted,
                      color: comment.hasVoted
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      onTap: onLike,
                    ),
                    const SizedBox(width: 24),
                    _CommentActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "Rispondi",
                      isActive: false,
                      color: colorScheme.onSurfaceVariant,
                      onTap: onReply,
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onReport,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.flag_outlined,
                            size: 18,
                            color: colorScheme.outline.withValues(alpha: 0.5),
                          ),
                        ),
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

class _CommentActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  const _CommentActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
