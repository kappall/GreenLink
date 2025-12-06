import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/ui.dart';
import 'package:greenlinkapp/features/auth/pages/login.dart';
import 'package:greenlinkapp/features/auth/pages/register.dart';
import 'package:greenlinkapp/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

CustomTransitionPage noAnimationPage(Widget child) {
  return CustomTransitionPage(
    transitionsBuilder: (_, __, ___, child) => child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    child: child,
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerListenable = ValueNotifier<bool>(true);

  ref.listen<AuthState>(authProvider, (previous, next) {
    routerListenable.value = !routerListenable.value;
  });

  ref.onDispose(() => routerListenable.dispose());

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',

    refreshListenable: routerListenable,

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.uri.path == '/login';
      final isRegistering = state.uri.path == '/register';

      if (authState.isLoading) return null;

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            noAnimationPage(const HomeScreenPlaceholder()),
      ),

      GoRoute(
        path: '/ui',
        pageBuilder: (context, state) =>
            noAnimationPage(const ComponentShowcaseScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => noAnimationPage(const RegisterPage()),
      ),

      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => noAnimationPage(const LoginPage()),
      ),
    ],
  );
});

class HomeScreenPlaceholder extends StatelessWidget {
  const HomeScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Home", style: TextStyle(fontSize: 32))),
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
