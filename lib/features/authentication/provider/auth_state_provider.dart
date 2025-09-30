import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthState.unauthenticated());

  final AuthRepository _repo;

  Future<void> signUp({required String email, required String password}) async {
    state = const AuthState.loading();
    final result = await _repo.signUpWithEmail(email: email, password: password);
    result.when(
      success: (cred) {
        final user = cred.user;
        if (user == null) {
          state = const AuthState.failure(message: 'ユーザー作成に失敗しました（user=null）');
        } else {
          state = AuthState.authenticated(user: user);
        }
      },
      failure: (err) {
        state = AuthState.failure(message: err);
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();
    final result = await _repo.signInWithEmail(email: email, password: password);
    result.when(
      success: (cred) {
        final user = cred.user;
        if (user == null) {
          state = const AuthState.failure(message: 'ログインに失敗しました（user=null）');
        } else {
          state = AuthState.authenticated(user: user);
        }
      },
      failure: (err) {
        state = AuthState.failure(message: err);
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    final result = await _repo.signOut();
    result.when(
      success: (_) => state = const AuthState.unauthenticated(),
      failure: (err) => state = AuthState.failure(message: err),
    );
  }
}
