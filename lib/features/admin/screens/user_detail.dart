import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/ui.dart';
import '../models/user.dart';
import '../providers/admin_provider.dart';

class UserDetailScreen extends ConsumerWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dettagli Utente",
          style: TextStyle(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(user.isBlocked ? Icons.lock_open : Icons.block),
            color: user.isBlocked ? Colors.white : Colors.red,
            onPressed: () => _showBlockDialog(context, user, ref),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onPrimary),
            onPressed: () => _showManagementOptions(context, user, ref),
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
              "Metriche Attività",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildStatsGrid(user),
            const SizedBox(height: 20),
            Text(
              "Contenuti Pubblicati",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, User user) {
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
            UiBadge(
              label: user.role.name.toUpperCase(),
              color: Colors.blueGrey,
            ),
            if (user.isBlocked)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: UiBadge(label: "BLOCCATO", color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(User user) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      children: [
        _StatItem(label: "Post Totali", value: '0', color: Colors.green),
        _StatItem(label: "Eventi Partecipati", value: '0', color: Colors.green),
        _StatItem(
          label: "Segnalazioni Ricevute",
          value: '0',
          color: Colors.orange,
        ),
        _StatItem(
          label: "Data Iscrizione",
          value:
              "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  void _showBlockDialog(BuildContext context, User user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.isBlocked ? "Sbloccare Utente?" : "Bloccare Utente?"),
        content: Text(
          user.isBlocked
              ? "L'utente potrà di nuovo accedere e pubblicare."
              : "Questo utente perderà l'accesso all'app e non potrà creare contenuti.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annulla"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: user.isBlocked ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(adminServiceProvider).blockUser(user.id);
              ref.invalidate(usersListProvider);
            },
            child: Text(user.isBlocked ? "Sblocca" : "Blocca"),
          ),
        ],
      ),
    );
  }

  void _showManagementOptions(BuildContext context, User user, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                "Elimina Account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(adminServiceProvider).blockUser(user.id);
                ref.invalidate(usersListProvider);
              },
            ),
          ],
        ),
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
