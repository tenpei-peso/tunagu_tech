// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../authentication/provider/auth_state_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      //ログアウトボタン
      floatingActionButton: FloatingActionButton(
        onPressed: authNotifier.signOut,
        child: const Icon(Icons.logout),
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
