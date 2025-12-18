import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/feed/widgets/reportdialog.dart';
import 'package:greenlinkapp/features/feed/widgets/imagesview.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/utils/time_passed_by.dart';
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final bool insidePost;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.insidePost = false,
    
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26, // diametro = radius * 2
              backgroundColor: Colors.grey[200],
              child: Text(
                post.author!.displayName[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.author!.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(getTimePassedBy(post.createdAt)), // time passed since post creation
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                UiBadge(
                  label: post.category.name,
                  icon: Icons.warning_amber_rounded,
                  color: Colors.blue,
                ),
                InkWell(
                  onTap: () {
                    showReportDialog(context, item: post);
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

        Text(post.description),

        if (post.IMMAGINI.isNotEmpty) ...[
          const SizedBox(height: 12),
          ImagesView(imageUrl: post.IMMAGINI, insidePost: insidePost),
        ],

        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text("${post.latitude}, ${post.longitude}"),
          ],
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            if (!insidePost) ...[
              Icon(Icons.trending_up, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${post.votes.length} Upvotes'),
              const SizedBox(width: 16),
              Icon(Icons.comment, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${post.COMMENTI.length} Commenti'),
            ],
          ],
        ),
      ],
    );
  }
}
