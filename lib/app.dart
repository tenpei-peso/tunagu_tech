// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'root/presentation/root_screen.dart';
import 'theme/Tunagu_themes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = TunaguThemes.getThemeFromScheme(TunaguThemes.lightColors);
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: child!,
      ),
      title: 'Tunagu',
      theme: theme,
      locale: const Locale('ja', 'JP'),
      home: const RootScreen(),
    );
  }
}
