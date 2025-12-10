import 'package:flutter/material.dart';

class UiBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showAdmin;

  const UiBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      elevation: 3,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.message_outlined),
          selectedIcon: Icon(Icons.message),
          label: 'Post',
        ),
        const NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: 'Mappa',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Volontariato',
        ),
        if (showAdmin)
          const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
      ],
    );
  }
}