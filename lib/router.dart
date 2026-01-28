import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/admin/pages/create_partner_page.dart';
import 'package:greenlinkapp/features/auth/models/auth_state.dart';
import 'package:greenlinkapp/features/auth/pages/login.dart';
import 'package:greenlinkapp/features/auth/pages/register.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/pages/create_event_page.dart';
import 'package:greenlinkapp/features/event/pages/event_info.dart';
import 'package:greenlinkapp/features/event/pages/event_qr_scanner_page.dart';
import 'package:greenlinkapp/features/event/pages/volunteering_feed_page.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/pages/feed_page.dart';
import 'package:greenlinkapp/features/feed/pages/post_info.dart';
import 'package:greenlinkapp/features/main-wrapper/pages/main_wrapper.dart';
import 'package:greenlinkapp/features/map/pages/map.dart';
import 'package:greenlinkapp/features/settings/pages/settings_page.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import 'features/admin/pages/admin_wrapper.dart';
import 'features/admin/pages/reports_page.dart';
import 'features/admin/pages/user_detail_page.dart';
import 'features/admin/pages/users_page.dart';
import 'features/auth/pages/onboarding_page.dart';
import 'features/auth/pages/partner_activation_page.dart';
import 'features/auth/providers/onboarding_provider.dart';
import 'features/feed/pages/create_post.dart';
import 'features/settings/pages/change_password.dart';
import 'features/user/pages/edit_profile_page.dart';
import 'features/user/pages/profile_page.dart';

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
  // Ascolta authProvider per rimuovere la splash screen
  ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
    if (!next.isLoading) {
      FlutterNativeSplash.remove();
    }
  });

  // Listener per forzare il refresh del router quando cambia l'auth o l'onboarding
  final routerListenable = ValueNotifier<bool>(true);
  ref.listen(authProvider, (previous, next) {
    final prevIsLoggedIn = previous?.value?.isLoggedIn ?? false;
    final nextIsLoggedIn = next.value?.isLoggedIn ?? false;
    final prevIsAuthenticated = previous?.value?.isAuthenticated ?? false;
    final nextIsAuthenticated = next.value?.isAuthenticated ?? false;

    if (prevIsLoggedIn != nextIsLoggedIn ||
        prevIsAuthenticated != nextIsAuthenticated) {
      routerListenable.value = !routerListenable.value;
    }
  });
  ref.listen(
    onboardingProvider,
    (_, __) => routerListenable.value = !routerListenable.value,
  );

  ref.onDispose(() => routerListenable.dispose());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/login',
    refreshListenable: routerListenable,
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);
      final hasCompletedOnboarding = ref.read(onboardingProvider);

      // Se sta caricando l'autenticazione, non fare nulla (resta sulla splash)
      if (authAsync.isLoading) return null;

      final authState = authAsync.value;
      final isLoggedIn = authState?.isLoggedIn ?? false;
      final isAuthenticated = authState?.isAuthenticated ?? false;
      final isAdmin = authState?.isAdmin ?? false;

      final path = state.uri.path;
      final isLoggingIn = path == '/login';
      final isRegistering = path == '/register';
      final isPartnerActivation = path == '/partner-token';
      final isIntro = path == '/onboarding';
      final isAdminRoute = path.startsWith('/admin');

      final isSharedRoute = [
        '/profile',
        '/settings',
        '/post-info',
        '/event-info',
      ].contains(path);

      // 1. UTENTE NON AUTENTICATO (isAuthenticated is false). Questo include gli anonimi.
      if (!isAuthenticated) {
        // CASO A: L'utente è anonimo (isLoggedIn è true)
        if (isLoggedIn) {
          // Se un utente anonimo prova ad accedere a login/register, mandalo alla home.
          if (isLoggingIn || isRegistering || isPartnerActivation) {
            return '/home';
          }
          // Altrimenti può navigare liberamente.
          return null;
        }

        // CASO B: L'utente è completamente disconnesso (isLoggedIn è false)
        // Se sta tentando di accedere a una pagina di autenticazione, va bene.
        if (isLoggingIn || isRegistering || isPartnerActivation) {
          return null;
        }

        // Altrimenti, reindirizzalo al login.
        return '/login';
      }

      // 2. UTENTE AUTENTICATO (isAuthenticated is true)
      // GESTIONE ADMIN
      if (isAdmin) {
        if (isLoggingIn ||
            isRegistering ||
            isPartnerActivation ||
            (!isAdminRoute && !isSharedRoute)) {
          return '/admin/reports';
        }
        return null;
      }

      // GESTIONE ONBOARDING (solo per utenti reali)
      if (!hasCompletedOnboarding) {
        if (isIntro) return null; // Già in onboarding
        return '/onboarding'; // Forza l'onboarding
      }

      // Se un utente autenticato prova a tornare a login/register/onboarding,
      // reindirizzalo alla home.
      if (isLoggingIn ||
          isRegistering ||
          isPartnerActivation ||
          isIntro ||
          isAdminRoute) {
        return '/home';
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
                builder: (context, state) =>
                    MapPage(targetLocation: state.extra as MapTargetLocation?),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/volunteering',
                builder: (context, state) => const VolunteeringFeedPage(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminWrapper(navigationShell: navigationShell);
        },
        branches: [
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
      GoRoute(path: '/admin', redirect: (context, state) => '/admin/reports'),
      GoRoute(
        path: '/admin/create-partner',
        builder: (context, state) => const CreatePartnerPage(),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfilePage(),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const EditProfilePage(),
          ),
        ],
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
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/partner-token',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            noAnimationPage(const PartnerActivationPage()),
      ),
      GoRoute(
        path: '/post-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final post = state.extra as PostModel;
          return PostInfoPage(post: post);
        },
      ),
      GoRoute(
        path: '/event-info',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final event = state.extra as EventModel;
          return EventInfoPage(event: event);
        },
      ),
      GoRoute(
        path: '/event/:eventId/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventQrScannerPage(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/create-post',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePostPage(),
      ),
      GoRoute(
        path: '/create-event',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: '/change-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChangePasswordPage(),
      ),
    ],
  );
});
