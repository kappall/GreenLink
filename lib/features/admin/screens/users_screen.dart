import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/admin/widgets/empty_user_state.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';

import '../../user/models/user_model.dart';
import '../providers/admin_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/user_search_bar.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);
    final selectedRole = ref.watch(userRoleFilterProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  UsersSearchBar(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text("Tutti"),
                        selected: selectedRole == null,
                        onSelected: (_) =>
                            ref.read(userRoleFilterProvider.notifier).state =
                                null,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text("Utenti"),
                        selected: selectedRole == AuthRole.user,
                        onSelected: (_) =>
                            ref.read(userRoleFilterProvider.notifier).state =
                                AuthRole.user,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text("Partner"),
                        selected: selectedRole == AuthRole.partner,
                        onSelected: (_) =>
                            ref.read(userRoleFilterProvider.notifier).state =
                                AuthRole.partner,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: const TabBar(
                tabs: [
                  Tab(text: "ATTIVI"),
                  Tab(text: "BLOCCATI"),
                ],
              ),
            ),
            Expanded(
              child: usersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Errore: $e')),
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
      return EmptyUsersState(
        isSearching: ref.watch(usersSearchQueryProvider).isNotEmpty,
        query: ref.watch(usersSearchQueryProvider),
        onClearSearch: () {
          ref.read(usersSearchQueryProvider.notifier).state = '';
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => UserCard(
        user: users[i],
        onOptionsTap: () =>
            showUserOptions(context, users[i], (int userId) async {
              await ref.read(adminServiceProvider).blockUser(userId);
              ref.invalidate(usersListProvider);
            }),
      ),
    );
  }
}

void showUserOptions(
  BuildContext context,
  UserModel user,
  Future<void> Function(int) onBlockUser,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text("Opzioni per ${user.displayName}")),
          ListTile(
            leading: Icon(user.isBlocked ? Icons.lock_open : Icons.block),
            title: Text(user.isBlocked ? "Sblocca Accesso" : "Blocca Accesso"),
            onTap: () async {
              Navigator.pop(context);
              await onBlockUser(user.id);
            },
          ),
        ],
      ),
    ),
  );
}
