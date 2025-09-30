import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/presentation/welcme_screen.dart';
import '../../features/authentication/provider/auth_state.dart';
import '../../features/authentication/provider/auth_state_provider.dart';
import 'tab_screen.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      // 未認証（初期状態も含む）
      unauthenticated: (loading) {
        if (loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const WelcomeScreen();
      },

      // ローディング中
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      // 認証済み → TabScreenへ
      authenticated: (user) => const TabScreen(),

      // 認証失敗
      failure: (message) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('エラー: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 再試行とかログアウトなど
                  ref.read(authNotifierProvider.notifier).signOut();
                },
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
