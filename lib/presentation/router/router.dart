// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../features/authentication/presentation/welcme_screen.dart';
import '../features/authentication/provider/auth_state.dart';
import '../features/authentication/provider/auth_state_provider.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/message/presentation/message_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/setting/presentation/setting_screen.dart';
import '../root/root_screen.dart';
import 'router_path_name.dart';
import 'router_refresh_notifier.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authNotifierProvider);
  // AuthNotifier の state 変更を流す stream
  final authStream = ref.watch(authNotifierProvider.notifier).stream;

  // Listenable を作成して、Riverpod のライフサイクルに乗せて破棄
  final refresh = GoRouterRefreshNotifier(authStream);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RoutePathName.welcome,
    refreshListenable: refresh,
    redirect: (context, state) {
      final isAuthed = auth.when(
        authenticated: (_) => true,
        loading: () => false,
        failure: (_) => false,
        unauthenticated: (_) => false,
      );

      if (!isAuthed && state.fullPath != RoutePathName.welcome) {
        return RoutePathName.welcome;
      }
      if (isAuthed && state.fullPath == RoutePathName.welcome) {
        return RoutePathName.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePathName.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) =>
            RootScreen(navigationShell: navShell),
        branches: [
          // /app/home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // /app/search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // /app/message
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.message,
                builder: (context, state) => const MessageScreen(),
              ),
            ],
          ),
          // /app/settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
