import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';

import '../models/user.dart';
import '../providers/admin_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateUserRole(User user, AuthRole newRole) async {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Aggiornamento ruolo di ${user.displayName}...")),
    );

    await ref.read(adminServiceProvider).updateUserRole(user.id, newRole);

    ref.invalidate(usersListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Ruolo aggiornato a ${newRole.name}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _blockUser(User user) async {
    Navigator.pop(context);

    await ref.read(adminServiceProvider).blockUser(user.id);

    ref.invalidate(usersListProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Utente ${user.displayName} bloccato"),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cerca per nome o email...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),

          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Errore: $err')),
              data: (users) {
                final filteredUsers = users.where((u) {
                  return u.displayName.toLowerCase().contains(_searchQuery) ||
                      u.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _UserCard(
                      user: filteredUsers[index],
                      onOptionsTap: () =>
                          _showUserOptions(context, filteredUsers[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? "Nessun utente trovato"
                : "Nessun risultato per '$_searchQuery'",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showUserOptions(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  "Opzioni per ${user.displayName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text("Cambia Ruolo"),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRolePickerSheet(context, user);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                  color: user.isBlocked ? Colors.green : Colors.red,
                ),
                title: Text(
                  user.isBlocked ? "Sblocca Accesso" : "Blocca Accesso",
                  style: TextStyle(
                    color: user.isBlocked ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () => _blockUser(user),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Vedi dettagli completi"),
                onTap: () {
                  // TODO: Navigazione a pagina dettagli
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRolePickerSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Assegna nuovo ruolo a ${user.displayName}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              ...[AuthRole.partner, AuthRole.user].map((role) {
                final isCurrentRole = user.role == role;
                return InkWell(
                  onTap: isCurrentRole
                      ? null
                      : () => _updateUserRole(user, role),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCurrentRole
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isCurrentRole
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            role.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              fontWeight: isCurrentRole
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isCurrentRole)
                          Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onOptionsTap;

  const _UserCard({required this.user, required this.onOptionsTap});

  @override
  Widget build(BuildContext context) {
    Color roleColor;
    switch (user.role) {
      case AuthRole.partner:
        roleColor = Colors.blue;
        break;
      case AuthRole.user:
        roleColor = Colors.green;
        break;
      default:
        roleColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: roleColor.withValues(alpha: 0.1),
          child: Text(
            user.displayName.isNotEmpty
                ? user.displayName[0].toUpperCase()
                : "?",
            style: TextStyle(color: roleColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                user.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: roleColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                user.role.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onPressed: onOptionsTap,
        ),
      ),
    );
  }
}
