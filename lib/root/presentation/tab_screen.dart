// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../features/authentication/provider/auth_state_provider.dart';

class TabScreen extends ConsumerWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("ログイン後のホーム画面"),
      ),
    );
  }
}
