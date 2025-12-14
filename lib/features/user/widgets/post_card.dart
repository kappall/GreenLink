//temporaneo, da usare gli stessi del feed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/post/models/post_model.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/badge.dart';
import '../../../core/common/widgets/card.dart';
import '../../../core/providers/geocoding_provider.dart';
import '../providers/user_provider.dart';

extension PostCategoryUI on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.flood:
        return 'Alluvione';
      case PostCategory.fire:
        return 'Incendio';
      case PostCategory.earthquake:
        return 'Terremoto';
      case PostCategory.pollution:
        return 'Inquinamento';
      case PostCategory.storm:
        return 'Tempesta';
      case PostCategory.hurricane:
        return 'Uragano';
      case PostCategory.other:
        return 'Altro';
      case PostCategory.unknown:
        return 'Sconosciuto';
    }
  }

  IconData get icon {
    switch (this) {
      case PostCategory.flood:
        return Icons.water_drop;
      case PostCategory.fire:
        return Icons.local_fire_department;
      case PostCategory.earthquake:
        return Icons.landslide;
      case PostCategory.pollution:
        return Icons.factory;
      case PostCategory.storm:
        return Icons.storm;
      case PostCategory.hurricane:
        return Icons.cyclone;
      case PostCategory.other:
      case PostCategory.unknown:
        return Icons.question_mark;
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.flood:
        return Colors.blue;
      case PostCategory.fire:
        return Colors.red;
      case PostCategory.earthquake:
        return Colors.brown;
      case PostCategory.pollution:
        return Colors.grey;
      case PostCategory.storm:
        return Colors.indigo;
      case PostCategory.hurricane:
        return Colors.purple;
      case PostCategory.other:
      case PostCategory.unknown:
        return Colors.black;
    }
  }
}

class PostCard extends ConsumerWidget {
  final PostModel post;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isAmplified =
        currentUser != null &&
        post.votes.any((voter) => voter.id == currentUser.id);
    final timestamp = post.createdAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(post.createdAt!.toLocal())
        : '';
    final geoKey = (lat: post.latitude, lng: post.longitude);
    final location = ref.watch(placeNameProvider(geoKey)).value;

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
                        post.author?.displayName ?? 'Utente Sconosciuto',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timestamp,
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
                    if (post.category != PostCategory.other &&
                        post.category != PostCategory.unknown)
                      UiBadge(
                        label: post.category.label,
                        icon: post.category.icon,
                        color: post.category.color,
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
              post.description,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location ?? '',
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
                      color: isAmplified
                          ? const Color(0xFF059669)
                          : Colors.grey.shade600,
                    ),
                    label: Text(
                      isAmplified
                          ? 'Amplificato (${post.votes.length})'
                          : 'Amplifica (${post.votes.length})',
                      style: TextStyle(
                        color: isAmplified
                            ? const Color(0xFF059669)
                            : Colors.grey.shade600,
                        fontWeight: isAmplified
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                if (onComment != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onComment,
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      label: Text(
                        'Commenti',
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
