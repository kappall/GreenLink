import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/pulsing_icon.dart';
import 'package:greenlinkapp/core/services/socket_service.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';

class MainWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationStreamProvider, (previous, next) {
      final notification = next.value;
      if (notification != null && context.mounted) {
        final contentId = notification['contentId'];
        final type = notification['type'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text('Nuova segnalazione ($type) nelle vicinanze'),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'VEDI',
              onPressed: () async {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Caricamento...')),
                  );

                try {
                  final post = await ref
                      .read(postsProvider(null).notifier)
                      .fetchPostById(contentId.toString());

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  if (context.mounted) {
                    context.push('/post-info', extra: post);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Errore: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
    final todaysEvents = ref.watch(todaysEventsProvider);
    final hasTodaysEvents = ref.watch(todaysEventsProvider).isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GreenLink",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (hasTodaysEvents)
            IconButton(
              icon: PulsingIcon(
                icon: Icons.event_available,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: "Eventi di Oggi",
              onPressed: () {
                context.push('/event-info', extra: todaysEvents.first);
              },
            ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: "Profilo",
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mappa',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Volontariato',
          ),
        ],
      ),
    );
  }
}
