import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/providers/geocoding_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/utils/time_passed_by.dart';
import 'package:greenlinkapp/features/feed/widgets/report_dialog.dart';

class PostCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final geoKey = (lat: post.latitude, lng: post.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${post.latitude}, ${post.longitude}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey[200],
              child: const Text(
                '?',
                style: TextStyle(fontSize: 24, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Utente Anonimo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(getTimePassedBy(post.createdAt)),
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
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                locationName,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (!insidePost) ...[
              const Icon(Icons.trending_up, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('${post.votes_count} Upvotes'),
              const SizedBox(width: 16),
              const Icon(Icons.comment, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ],
    );
  }
}
