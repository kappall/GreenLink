import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            child: Text(
              comment.author.displayName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: theme.primaryColor,
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
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  comment.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _CommentActionButton(
                      icon: comment.hasVoted
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      label: comment.votesCount.toString(),
                      color: comment.hasVoted
                          ? theme.primaryColor
                          : Colors.grey.shade600,
                      onTap: onLike,
                    ),
                    const SizedBox(width: 24),

                    _CommentActionButton(
                      icon: Icons.reply_outlined,
                      label: "Rispondi",
                      color: Colors.grey.shade600,
                      onTap: onReply,
                    ),
                    const Spacer(),

                    IconButton(
                      icon: const Icon(Icons.flag_outlined, size: 18),
                      color: Colors.grey.shade400,
                      onPressed: onReport,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
  final VoidCallback? onTap;

  const _CommentActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
