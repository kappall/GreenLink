import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_provider.dart';

class AdminWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AdminWrapper({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GreenLink",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: colorScheme.onPrimary),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        indicatorColor: Colors.indigo.shade100,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.report_problem),
            label: 'Segnalazioni',
          ),
          NavigationDestination(icon: Icon(Icons.people), label: 'Utenti'),
        ],
      ),
    );
  }
}
