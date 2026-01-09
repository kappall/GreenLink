import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../../core/utils/feedback_utils.dart';
import '../providers/admin_provider.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final selectedRole = ref.watch(userRoleFilterProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text("Gestione Utenti"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(usersProvider.notifier).refresh(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/admin/create-partner'),
          icon: const Icon(Icons.add_business),
          label: const Text("Nuovo Partner"),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => ref
                        .read(usersSearchQueryProvider.notifier)
                        .setSearchQuery(val),
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
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text("Tutti"),
                          selected: selectedRole == null,
                          onSelected: (_) => ref
                              .read(userRoleFilterProvider.notifier)
                              .setRoleFilter(null),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text("Utenti"),
                          selected: selectedRole == AuthRole.user,
                          onSelected: (_) => ref
                              .read(userRoleFilterProvider.notifier)
                              .setRoleFilter(AuthRole.user),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text("Partner"),
                          selected: selectedRole == AuthRole.partner,
                          onSelected: (_) => ref
                              .read(userRoleFilterProvider.notifier)
                              .setRoleFilter(AuthRole.partner),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: "ATTIVI"),
                Tab(text: "BLOCCATI"),
              ],
            ),
            Expanded(
              child: usersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Errore: $err')),
                data: (_) => TabBarView(
                  children: [
                    _UserList(users: ref.watch(activeFilteredUsersProvider)),
                    _UserList(users: ref.watch(blockedFilteredUsersProvider)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserList extends ConsumerWidget {
  final List<UserModel> users;

  const _UserList({required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (users.isEmpty) {
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
            const Text(
              "Nessun utente trovato",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _UserCard(
          user: users[index],
          onOptionsTap: () => _showUserOptions(context, ref, users[index]),
        );
      },
    );
  }

  void _showUserOptions(BuildContext context, WidgetRef ref, UserModel user) {
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  user.isBlocked ? Icons.lock_open : Icons.block,
                  color: user.isBlocked ? Colors.green : Colors.red,
                ),
                title: Text(
                  user.isBlocked ? "Sblocca Accesso" : "Blocca Accesso",
                  style: TextStyle(
                    color: user.isBlocked ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref
                      .read(userActionsProvider.notifier)
                      .blockUser(user.id);
                  if (context.mounted) {
                    FeedbackUtils.showSuccess(
                      context,
                      user.isBlocked ? "Utente sbloccato" : "Utente bloccato",
                    );
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Vedi dettagli completi"),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/admin/users/${user.id}', extra: user);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
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
        title: Text(
          user.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
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
                user.role?.name.toUpperCase() ?? "SCONOSCIUTO",
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
