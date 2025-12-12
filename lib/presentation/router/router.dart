// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../features/authentication/presentation/welcme_screen.dart';
import '../features/authentication/provider/auth_state.dart';
import '../features/authentication/provider/auth_state_provider.dart';
import '../features/budget/calendar/presentation/budget_calendar_screen.dart';
import '../features/budget/graph/presentation/budget_graph_screen.dart';
import '../features/budget/home/presentation/budget_home_screen.dart';
import '../features/budget/todo/presentation/budget_todo_screen.dart';
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.home,
                builder: (context, state) => const BudgetHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.calendar,
                builder: (context, state) => const BudgetCalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.todo,
                builder: (context, state) => const BudgetTodoScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePathName.graph,
                builder: (context, state) => const BudgetGraphScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
