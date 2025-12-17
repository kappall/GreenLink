import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/post_card.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../feed/providers/post_provider.dart';
import '../providers/admin_provider.dart';

class UserDetailPage extends ConsumerWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final userPosts = ref.watch(postsProvider);
    final userEvents = ref.watch(eventsProvider);
    final userComments = ref.watch(userCommentProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Dettagli Utente", style: TextStyle(color: Colors.white)),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.block),
            color: Colors.red,
            onPressed: () => _showBlockDialog(context, user, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard(context, user),

            const SizedBox(height: 20),
            Text(
              "Metriche Attività ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildStatsGrid(
              user,
              userPosts.asData?.value.length ?? 0,
              userEvents.asData?.value.length ?? 0,
              userComments.where((c) => c.userId == user.id).length,
            ),
            const SizedBox(height: 20),
            Text(
              "Contenuti Pubblicati ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            userPosts.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Text("Nessun post pubblicato. ");
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) => PostCard(post: posts[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Errore: $e "),
            ),
            if (user.role == AuthRole.partner) ...[
              const SizedBox(height: 20),
              Text(
                "Eventi Creati ",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              userEvents.when(
                data: (events) {
                  final eventsByUser = events
                      .where((e) => e.author?.id == user.id)
                      .toList();
                  if (eventsByUser.isEmpty) {
                    return const Text("Nessun evento creato. ");
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventsByUser.length,
                    itemBuilder: (context, index) =>
                        Text(eventsByUser[index].description),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text("Errore: $e "),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return UiCard(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(user.email, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary),
              ),
              child: Text(
                roleLabel(user.role ?? AuthRole.unknown),
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    UserModel user,
    int postCount,
    int eventCount,
    int commentCount,
  ) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      children: [
        _StatItem(
          label: "Post Totali ",
          value: postCount.toString(),
          color: Colors.green,
        ),
        _StatItem(
          label: "Eventi Creati ",
          value: eventCount.toString(),
          color: Colors.blue,
        ),
        _StatItem(
          label: "Commenti ",
          value: commentCount.toString(),
          color: Colors.orange,
        ),
        _StatItem(
          label: "Data Iscrizione ",
          value: user.createdAt != null
              ? "${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year} "
              : "N/A ",
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  void _showBlockDialog(BuildContext context, UserModel user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Bloccare Utente? "),
        content: const Text(
          "Questo utente perderà l'accesso all'app e non potrà creare contenuti. ",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annulla "),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminServiceProvider).blockUser(user.id);
              ref.invalidate(usersListProvider);
            },
            child: const Text("Blocca "),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return UiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
