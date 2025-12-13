//temporaneo, da usare gli stessi del feed
import 'package:flutter/material.dart';

import '../../../core/common/widgets/ui.dart';
import '../../../data/tmp.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onAmplify;
  final VoidCallback? onComment;
  final VoidCallback? onReport;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onAmplify,
    this.onComment,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return UiCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        post.timestamp,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UiBadge(
                      label: post.type.label,
                      icon: post.type.icon,
                      color: post.type.color,
                    ),
                    if (onReport != null)
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onPressed: onReport,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),

          if (post.images != null && post.images!.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: post.images!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          post.images![index],
                          fit: BoxFit.cover,
                          loadingBuilder: (ctx, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (ctx, error, stackTrace) => Container(
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    if (post.images!.length > 1)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "+ ${post.images!.length} foto",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    post.location,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onAmplify,
                    icon: Icon(
                      Icons.trending_up,
                      size: 20,
                      color: post.isAmplified
                          ? const Color(0xFF059669)
                          : Colors.grey.shade600,
                    ),
                    label: Text(
                      post.isAmplified
                          ? "Amplificato (${post.amplifications})"
                          : "Amplifica (${post.amplifications})",
                      style: TextStyle(
                        color: post.isAmplified
                            ? const Color(0xFF059669)
                            : Colors.grey.shade600,
                        fontWeight: post.isAmplified
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: TextButton.icon(
                    onPressed: onComment,
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    label: Text(
                      "${post.commentsCount} Commenti",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
