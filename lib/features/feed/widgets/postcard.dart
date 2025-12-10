import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/feed/domain/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.authorName, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(post.authorRole),
            Text(post.timeAgo),

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
            Text(post.location),

            const SizedBox(height: 12),
            Row(
              children: [
                Text('${post.likes} Amplifica'),
                const SizedBox(width: 16),
                Text('${post.comments} Commenti'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

