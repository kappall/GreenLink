import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/map/provider/map_provider.dart';

class MapSummary extends ConsumerWidget {
  const MapSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(filteredMapPostsProvider);
    final events = ref.watch(filteredMapEventsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.post_add, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Text('${posts.length} segnalazioni'),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text('${events.length} eventi'),
            ],
          ),
        ],
      ),
    );
  }
}
