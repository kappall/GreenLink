import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/pulsing_icon.dart';
import 'package:greenlinkapp/core/services/socket_service.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';

import '../../event/models/event_model.dart';

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
        final type = notification['type'];
        void handleTap() async {
          try {
            if (type == 'Post') {
              final post = PostModel.fromJson(notification);
              if (context.mounted) {
                context.push('/post-info', extra: post);
              }
            } else if (type == 'Event') {
              final event = EventModel.fromJson(notification);
              if (context.mounted) {
                context.push('/event-info', extra: event);
              }
            }
          } catch (e) {
            if (context.mounted) {
              ElegantNotification.error(
                title: const Text("Errore"),
                description: Text(
                  "Impossibile aprire la notifica: ${e.toString()}",
                ),
              ).show(context);
            }
          }
        }

        if (type == 'Post') {
          ElegantNotification.info(
            animation: AnimationType.fromTop,
            position: Alignment.topCenter,
            height: 100,
            toastDuration: Duration(milliseconds: 6000),
            verticalDividerColor: Colors.white,
            background: Colors.red,
            title: null,
            description: const Text("Nuova Segnalazione nelle vicinanze"),
            action: TextButton(
              onPressed: handleTap,
              child: const Text(
                "VEDI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).show(context);
        } else if (type == 'Event') {
          ElegantNotification.info(
            animation: AnimationType.fromTop,
            position: Alignment.topCenter,
            height: 100,
            verticalDividerColor: Colors.white,
            background: Colors.green,
            title: null,
            description: const Text("Nuovo Evento nelle vicinanze"),
            action: TextButton(
              onPressed: handleTap,
              child: const Text(
                "VEDI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).show(context);
        }
      }
    });
    final todaysEvents = ref.watch(todaysEventsProvider);
    final hasTodaysEvents = todaysEvents.isNotEmpty;

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
        height: 60,
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
