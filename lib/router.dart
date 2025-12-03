import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/ui.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RootScreenPlaceholder(),
    ),

    GoRoute(
      path: '/ui',
      builder: (context, state) => const ComponentShowcaseScreen(),
    ),
  ],
);

class RootScreenPlaceholder extends StatelessWidget {
  const RootScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => router.push('/ui'),
          child: Text("See components", style: TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}

class ComponentShowcaseScreen extends StatelessWidget {
  const ComponentShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenLink UI Kit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const Text(
              "Buttons",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(onPressed: () {}, child: const Text("Primary")),
                OutlinedButton(onPressed: () {}, child: const Text("Outline")),
                TextButton(onPressed: () {}, child: const Text("Ghost")),
              ],
            ),

            const Divider(),
            const Text("Badges", style: TextStyle(fontWeight: FontWeight.bold)),
            const Wrap(
              spacing: 8,
              children: [
                UiBadge(
                  label: "Pulizia",
                  color: Colors.blue,
                  icon: Icons.delete_outline,
                ),
                UiBadge(
                  label: "Emergenza",
                  color: Colors.red,
                  icon: Icons.warning_amber,
                ),
                UiBadge(
                  label: "Posti esauriti",
                  isOutline: true,
                  color: Colors.red,
                ),
              ],
            ),

            const Divider(),
            const Text("Alert", style: TextStyle(fontWeight: FontWeight.bold)),
            const UiAlert(
              title: "Attenzione",
              description:
                  "Stai navigando in modalità anonima. Registrati per pubblicare.",
              icon: Icons.info_outline,
            ),

            const Divider(),
            const Text("Card", style: TextStyle(fontWeight: FontWeight.bold)),
            UiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Titolo della Card",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Questo è il contenuto della card, simile a quella di Shadcn UI.",
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text("Azione"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UiBottomNavigation(currentIndex: 0),
    );
  }
}
