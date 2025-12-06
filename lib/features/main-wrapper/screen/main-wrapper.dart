import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GreenLink",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
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
