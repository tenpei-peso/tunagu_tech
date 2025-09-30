import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'sign_in_form_state.dart';

final signInFormProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignInFormNotifier(repo);
});

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  SignInFormNotifier(this._repo) : super(const SignInFormState());

  final AuthRepository _repo;

  // ---- setters ----
  void setEmail(String v) {
    state = state.copyWith(
      email: v,
      emailError: _validateEmail(v),
      isValid: _canSubmit(v, state.password),
    );
  }

  void setPassword(String v) {
    state = state.copyWith(
      password: v,
      passwordError: _validatePassword(v),
      isValid: _canSubmit(state.email, v),
    );
  }

  // ---- submit ----
  Future<void> submit() async {
    if (state.isSubmitting) return;

    final emailErr = _validateEmail(state.email);
    final passErr  = _validatePassword(state.password);

    if (emailErr != null || passErr != null) {
      state = state.copyWith(
        emailError: emailErr,
        passwordError: passErr,
        isValid: false,
      );
      return;
    }

    state = state.copyWith(isSubmitting: true);

    final res = await _repo.signInWithEmail(
      email: state.email,
      password: state.password,
    );

    res.when(
      success: (_) {
        // 成功時は FirebaseAuth がログイン状態に -> authStateChanges() が発火して RootScreen が自動遷移
        state = state.copyWith(
          isSubmitting: false,
          emailError: null,
          passwordError: null,
        );
      },
      failure: (err) {
        state = state.copyWith(
          isSubmitting: false,
          passwordError: _mapAuthError(err),
        );
      },
    );
  }

  // ---- validators ----
  String? _validateEmail(String v) {
    if (v.isEmpty) return 'メールを入力してください';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return ok ? null : 'メール形式が不正です';
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return 'パスワードを入力してください';
    return v.length >= 6 ? null : '6文字以上で入力してください';
  }

  bool _canSubmit(String email, String pass) =>
      _validateEmail(email) == null && _validatePassword(pass) == null;

  // ---- error mapping ----
  String _mapAuthError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('user-not-found')) {
      return 'ユーザーが見つかりません';
    } else if (lower.contains('wrong-password')) {
      return 'メールまたはパスワードが正しくありません';
    } else if (lower.contains('invalid-email')) {
      return 'メールアドレスの形式が正しくありません';
    } else if (lower.contains('user-disabled')) {
      return 'このアカウントは無効化されています';
    } else if (lower.contains('too-many-requests')) {
      return 'リクエストが多すぎます。時間をおいて再度お試しください';
    } else if (lower.contains('network-request-failed')) {
      return 'ネットワークエラーが発生しました。通信環境をご確認ください';
    }
    return 'ログインに失敗しました（$raw）';
  }

  void reset() => state = const SignInFormState();
}
