import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/feed/domain/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: UiCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26, // diametro = radius * 2
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0] : '',
                    style: const TextStyle(fontSize: 24, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(post.authorRole),
                      Text(post.timeAgo),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UiBadge(
                      label: post.eventType,
                      icon: Icons.warning_amber_rounded,
                      color: Colors.blue,
                    ),
                    InkWell(
                      onTap: () {
                        // Segnala il post
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.flag_outlined,
                          color: Colors.grey[700],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(post.text),

            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(post.location),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${post.upvotes} Upvotes'),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${post.comments} Commenti'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
