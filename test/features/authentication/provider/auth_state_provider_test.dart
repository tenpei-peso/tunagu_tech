// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:tunagu/domain/repositories/auth_repository.dart';
import 'package:tunagu/features/authentication/provider/auth_state.dart';
import 'package:tunagu/features/authentication/provider/auth_state_provider.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockFirebaseAuth auth;
  late MockAuthRepository repo;
  late StreamController<User?> controller;

  setUp(() {
    auth = MockFirebaseAuth();
    repo = MockAuthRepository();
    controller = StreamController<User?>();
    when(() => auth.authStateChanges()).thenAnswer((_) => controller.stream);
    when(() => auth.currentUser).thenReturn(null); // 初期は未ログイン
  });

  tearDown(() async {
    await controller.close();
  });

  test('認証状態: 未認証 -> 認証済み -> 未認証', () async {
    final notifier = AuthNotifier(auth, repo);

    // 初期loadingだが_emitFromを同期で呼ぶのでAuthNotifier を作った瞬間にはもう unauthenticated
    expect(notifier.state, const AuthState.unauthenticated());

    // ログインイベントを流す
    final user = MockUser();
    when(() => auth.currentUser).thenReturn(user);
    controller.add(user);

    await Future<void>.delayed(Duration.zero);
    expect(
      notifier.state,
      AuthState.authenticated(user: user),
    );

    // ログアウトイベント
    when(() => auth.currentUser).thenReturn(null);
    controller.add(null);

    await Future<void>.delayed(Duration.zero);
    expect(notifier.state, const AuthState.unauthenticated());
  });
}
