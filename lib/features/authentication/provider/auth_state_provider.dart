// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../domain/global_provider/firebase_client_provider.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return AuthNotifier(auth, repo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._auth, this._repo) : super(const AuthState.loading()) {
    // 起動時の現在ユーザーを即反映
    _emitFrom(_auth.currentUser);

    // 以降は FirebaseAuth の状態変化を購読して自動反映
    _sub = _auth.authStateChanges().listen(
          _emitFrom,
          onError: (e, __) => state = AuthState.failure(message: e.toString()),
        );
  }

  final FirebaseAuth _auth;
  final AuthRepository _repo;
  StreamSubscription<User?>? _sub;

  void _emitFrom(User? user) {
    if (user == null) {
      state = const AuthState.unauthenticated();
    } else {
      state = AuthState.authenticated(user: user);
    }
  }

  /// サインアップ：成功時はストリームが authenticated を流すので、ここで state を直接いじらない
  Future<void> signUp({required String email, required String password}) async {
    state = const AuthState.loading();

    final result =
        await _repo.signUpWithEmail(email: email, password: password);

    result.when(
      success: (_) {
        // 何もしない：authStateChanges() が user を流してくる
      },
      failure: (err) {
        state = AuthState.failure(message: err);
      },
    );
  }

  /// サインイン：成功時はストリーム任せ
  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();

    final result =
        await _repo.signInWithEmail(email: email, password: password);

    result.when(
      success: (_) {
        // 何もしない：ストリームが反映
      },
      failure: (err) {
        state = AuthState.failure(message: err);
      },
    );
  }

  /// サインアウト：成功時はストリームで null が流れて unauthenticated へ
  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await _repo.signOut();

    result.when(
      success: (_) {
        // 何もしない：authStateChanges() が null を流す
      },
      failure: (err) {
        state = AuthState.failure(message: err);
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
