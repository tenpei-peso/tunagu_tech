// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../utility/result.dart';
import '../global_provider/firebase_client_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  //clientをDIする
  final client = ref.read(firebaseAuthProvider);
  //ここを書き換えると、別の実装に差し替えられる
  return FirebaseAuthRepositoryImpl(client);
});

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

class FirebaseAuthRepositoryImpl implements AuthRepository {
  FirebaseAuthRepositoryImpl(this._client);

  final FirebaseAuth _client;

  User? get currentUser => _client.currentUser;

  @override
  Future<Result<UserCredential>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _client.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(cred);
    } on FirebaseAuthException catch (e) {
      return Result.error('FirebaseAuthException: ${e.toString()}');
    } catch (e) {
      return Result.error('未知のエラー${e.toString()}');
    }
  }

  @override
  Future<Result<UserCredential>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _client.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(cred);
    } on FirebaseAuthException catch (e) {
      return Result.error('FirebaseAuthException: ${e.toString()}');
    } catch (e) {
      return Result.error('未知のエラー${e.toString()}');
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _client.signOut();
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      return Result.error('FirebaseAuthException: ${e.toString()}');
    } catch (e) {
      return Result.error('未知のエラー${e.toString()}');
    }
  }
}
