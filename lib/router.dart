import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/pages/login.dart';
import 'package:greenlinkapp/features/auth/pages/register.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/screen/event_info.dart';
import 'package:greenlinkapp/features/feed/screen/feed.dart';
import 'package:greenlinkapp/features/main-wrapper/screen/main-wrapper.dart';
import 'package:greenlinkapp/features/map/screen/map.dart';
import 'package:greenlinkapp/features/post/screen/post_info.dart';
import 'package:greenlinkapp/features/feed/domain/post.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';
import 'package:greenlinkapp/features/ui-showcase/ui_showcase_screen.dart';
import 'package:greenlinkapp/features/user/pages/profile.dart';
import 'package:greenlinkapp/features/volunteering/screen/volunteeringfeed.dart';

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
      final isLoggingIn = state.uri.path == '/login';
      final isRegistering = state.uri.path == '/register';

      if (authState.isLoading) return null;

      if (!isLoggedIn && !isLoggingIn && !isRegistering) return '/login';

      if (isLoggedIn && (isLoggingIn || isRegistering)) return '/home';

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
                path: '/volunteering',
                builder: (context, state) => const VolunteeringScreen(),
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
          final post = state.extra as Post;
          return PostInfoScreen(p: post);
        },
      ),

      GoRoute(
        path: '/event-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final event = state.extra as Event;
          return EventInfoScreen(e: event);
        },
      ),
      
      GoRoute(
        path: '/ui-demo',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UiShowcaseScreen(),
      ),
    ],
  );
});
