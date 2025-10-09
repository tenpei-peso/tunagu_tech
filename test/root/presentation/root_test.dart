import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tunagu/features/authentication/presentation/welcme_screen.dart';
import 'package:tunagu/features/authentication/provider/auth_state.dart';

import 'package:tunagu/features/authentication/provider/auth_state_provider.dart';
import 'package:tunagu/root/presentation/root_screen.dart';
import 'package:tunagu/root/presentation/tab_screen.dart';

import '../../features/authentication/provider/auth_state_provider_test.dart';


void main() {
  setUpAll(() async {
    // 1) Flutter のテスト環境を初期化
    TestWidgetsFlutterBinding.ensureInitialized();
    // 2) Firebase Core のメソッドチャネルをモック
    setupFirebaseCoreMocks();
    // 3) ダミーの DEFAULT App を作成
    await Firebase.initializeApp();
  });

  testWidgets('未認証なら Welcome を表示', (tester) async {
    // --- モック用意 ---
    final mockAuth = MockFirebaseAuth();
    final mockRepo = MockAuthRepository();

    // メソッドとしてスタブ（ゲッターではない）
    when(() => mockAuth.authStateChanges())
        .thenAnswer((_) => const Stream<User?>.empty());
    when(() => mockAuth.currentUser).thenReturn(null);

    // --- Provider 差し替え ---
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith((ref) {
            final notifier = AuthNotifier(mockAuth, mockRepo)
              ..state = const AuthState.unauthenticated(); // ← 明示的に未認証に
            return notifier;
          }),
        ],
        child: const MaterialApp(home: RootScreen()),
      ),
    );

    // 必要なら1フレーム進めて state 反映を安定させる
    await tester.pump();

    // --- 検証（← 期待を正しく） ---
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(TabScreen), findsNothing);
  });

  testWidgets('認証済みなら Tab を表示', (tester) async {
  final mockAuth = MockFirebaseAuth();
  final mockRepo = MockAuthRepository();
  final mockUser = MockUser();

  when(() => mockAuth.authStateChanges()).thenAnswer((_) => const Stream<User?>.empty());
  when(() => mockAuth.currentUser).thenReturn(mockUser);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith((ref) {
          final notifier = AuthNotifier(mockAuth, mockRepo)
            ..state = AuthState.authenticated(user: mockUser);
          return notifier;
        }),
      ],
      child: const MaterialApp(home: RootScreen()),
    ),
  );

  await tester.pump();

  expect(find.byType(TabScreen), findsOneWidget);
  expect(find.byType(WelcomeScreen), findsNothing);
});
}
