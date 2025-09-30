import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'sign_up_form_state.dart';

final signUpFormProvider =
    StateNotifierProvider.autoDispose<SignUpFormNotifier, SignUpFormState>(
        (ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignUpFormNotifier(repo);
});

class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier(this._repo) : super(const SignUpFormState());

  final AuthRepository _repo;

  // ---------- setters ----------
  void setName(String v) {
    state = state.copyWith(
      name: v,
      nameError: v.isEmpty ? '名前を入力してください' : null,
    );
  }

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

  // 送信（サインアップ）
  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    final emailErr = _validateEmail(state.email);
    final passErr = _validatePassword(state.password);

    if (emailErr != null || passErr != null) {
      state = state.copyWith(
        emailError: emailErr,
        passwordError: passErr,
        isValid: false,
      );
      return;
    }

    state = state.copyWith(isSubmitting: true);

    final res = await _repo.signUpWithEmail(
      email: state.email,
      password: state.password,
    );

    res.when(
      success: (_) {
        // 成功時は FirebaseAuth がサインイン状態になる → authStateChanges() が発火 → 画面は自動で切替
        state = state.copyWith(
          isSubmitting: false,
          // 成功したのでフォーム上のエラーメッセージは消しておく
          emailError: null,
          passwordError: null,
        );
      },
      failure: (err) {
        // よくある FirebaseAuth エラーをユーザー向け文言に変換
        final mapped = _mapAuthError(err);
        state = state.copyWith(isSubmitting: false, passwordError: mapped);
      },
    );
  }

  // ---------- validators ----------
  String? _validateEmail(String v) {
    if (v.isEmpty) {
      return 'メールを入力してください';
    }
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return ok ? null : 'メール形式が不正です';
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) {
      return 'パスワードを入力してください';
    }
    return v.length >= 6 ? null : '6文字以上で入力してください';
  }

  bool _canSubmit(String email, String pass) =>
      _validateEmail(email) == null && _validatePassword(pass) == null;

  // ---------- error mapping (任意で強化) ----------
  String _mapAuthError(String raw) {
    // あなたの Result.error は String を返す想定なので、コードを含む文字列から判定
    // 例: "FirebaseAuthException: email-already-in-use"
    final lower = raw.toLowerCase();
    if (lower.contains('email-already-in-use')) {
      return 'このメールアドレスは既に使用されています';
    } else if (lower.contains('invalid-email')) {
      return 'メールアドレスの形式が正しくありません';
    } else if (lower.contains('weak-password')) {
      return 'パスワードが弱すぎます（6文字以上を推奨）';
    } else if (lower.contains('network-request-failed')) {
      return 'ネットワークエラーが発生しました。通信環境を確認してください';
    }
    return 'アカウント作成に失敗しました（$raw）';
  }

  // ---------- 便利メソッド ----------
  void reset() => state = const SignUpFormState();
}
