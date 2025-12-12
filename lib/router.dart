import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/pages/login.dart';
import 'package:greenlinkapp/features/auth/pages/register.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/feed/screen/feed.dart';
import 'package:greenlinkapp/features/main-wrapper/screen/main-wrapper.dart';
import 'package:greenlinkapp/features/map/screen/map.dart';
import 'package:greenlinkapp/features/user/pages/profile.dart';
import 'package:greenlinkapp/features/volunteering/screen/volunteer.dart';

import 'features/settings/screens/settings_screen.dart';

CustomTransitionPage noAnimationPage(Widget child) {
  return CustomTransitionPage(
    transitionsBuilder: (_, __, ___, child) => child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    child: child,
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final routerProvider = Provider<GoRouter>((ref) {
  final routerListenable = ValueNotifier<bool>(true);

  ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
    routerListenable.value = !routerListenable.value;
  });

  ref.onDispose(() => routerListenable.dispose());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/home',

    refreshListenable: routerListenable,

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.asData?.value.isAuthenticated ?? false;
      final isAdmin = authState.asData?.value.isAdmin ?? false;

      final isLoggingIn = state.uri.path == '/login';
      final isRegistering = state.uri.path == '/register';
      final isAdminRoute = state.uri.path.startsWith('/admin');

      if (authState.isLoading) return null;

      if (!isLoggedIn && !isLoggingIn && !isRegistering) return '/login';

      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return isAdmin ? '/admin' : '/home';
      }

      if (isLoggedIn && !isAdmin && isAdminRoute) {
        return '/home';
      }

      if (isLoggedIn && isAdmin && !isAdminRoute) {
        return '/admin';
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const FeedScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const FeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/volunteer',
                builder: (context, state) => const VolunteerScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => noAnimationPage(const RegisterPage()),
      ),

      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => noAnimationPage(const LoginPage()),
      ),
    ],
  );
});
