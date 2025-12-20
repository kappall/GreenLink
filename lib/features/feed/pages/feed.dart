import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/feed/widgets/postcard.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cerca emergenze o luoghi...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bacheca Emergenze",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              
                ButtonWidget(
                  label: 'Nuovo Post',
                  onPressed: () {
                    print('Crea Nuovo Post premuto');
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
            ],
          ),

          postsAsync.when(
            data: (posts) => Column(
              children: [
                for (final p in posts)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: UiCard(
                      child: PostCard(post: p),
                      onTap: () => context.push('/post-info', extra: p),
                    ),
                  ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Errore nel caricamento dei post: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
