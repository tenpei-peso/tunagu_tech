import 'package:firebase_auth/firebase_auth.dart';
import '../../../utility/result.dart';

abstract class AuthRepository {
  /// ユーザー作成（SignUp）
  Future<Result<UserCredential>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// ユーザーログイン（SignIn）
  Future<Result<UserCredential>> signInWithEmail({
    required String email,
    required String password,
  });

  /// サインアウト
  Future<Result<void>> signOut();
}
