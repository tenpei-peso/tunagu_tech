// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'router/router.dart';
import 'theme/Tunagu_themes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = TunaguThemes.getThemeFromScheme(TunaguThemes.lightColors);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: child!,
      ),
      title: 'Tunagu',
      theme: theme,
      locale: const Locale('ja', 'JP'),
      routerConfig: router,
    );
  }
}
