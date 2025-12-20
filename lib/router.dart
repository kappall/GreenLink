import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/pages/login.dart';
import 'package:greenlinkapp/features/auth/pages/register.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/pages/event_info.dart';
import 'package:greenlinkapp/features/event/pages/volunteeringfeed.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/pages/feed.dart';
import 'package:greenlinkapp/features/feed/pages/post_info.dart';
import 'package:greenlinkapp/features/main-wrapper/pages/main_wrapper.dart';
import 'package:greenlinkapp/features/map/pages/map.dart';
import 'package:greenlinkapp/features/settings/pages/settings_page.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:greenlinkapp/features/user/pages/profile.dart';

import 'features/admin/pages/admin_dashboard_page.dart';
import 'features/admin/pages/admin_wrapper.dart';

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
              GoRoute(path: '/', builder: (context, state) => const FeedPage()),
              GoRoute(
                path: '/home',
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/volunteering',
                builder: (context, state) => const VolunteeringPage(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminWrapper(
            navigationShell: navigationShell,
          ); // Wrapper Admin
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin',
                builder: (context, state) => const AdminDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/reports',
                builder: (context, state) => const ReportsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/users',
                builder: (context, state) => const UsersPage(),
                routes: [
                  GoRoute(
                    path: ':userId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final user = state.extra as UserModel;
                      return UserDetailPage(user: user);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
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

      GoRoute(
        path: '/post-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final post = state.extra as PostModel;
          return PostInfoScreen(p: post);
        },
      ),

      GoRoute(
        path: '/event-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final event = state.extra as EventModel;
          return EventInfoPage(e: event);
        },
      ),
    ],
  );
});
