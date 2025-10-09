import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tunagu/domain/repositories/auth_repository.dart';
import 'package:tunagu/features/authentication/provider/sign_in_form_state_provider.dart';
import 'package:tunagu/utility/result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUserCredential extends Fake implements UserCredential {}

void main() {
  late MockAuthRepository repo;
  late SignInFormNotifier notifier;

  setUp(() {
    repo = MockAuthRepository();
    notifier = SignInFormNotifier(repo);
  });

  group('signIn:バリデーション', () {
    test('無効なメールアドレスはエラーを表示', () {
      notifier.setEmail('invalid');
      expect(notifier.state.emailError, isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('パスワードが6文字未満の場合はエラーを表示', () {
      notifier.setPassword('12345');
      expect(notifier.state.passwordError, isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('有効な入力はisValid=trueを設定', () {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');
      expect(notifier.state.isValid, isTrue);
    });
  });

  group('signIn:submit', () {
    test('成功時はエラーをクリアし、isSubmittingをトグルする', () async {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');

      when(() => repo.signInWithEmail(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => Result.success(FakeUserCredential()));

      // isSubmitting -> true
      final before = notifier.state;
      expect(before.isSubmitting, isFalse);

      final submitF = notifier.submit();
      expect(notifier.state.isSubmitting, isTrue);
      await submitF;

      final after = notifier.state;
      expect(after.isSubmitting, isFalse);
      expect(after.emailError, isNull);
      expect(after.passwordError, isNull);
    });

    test('失敗時はエラーメッセージをマッピングする', () async {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');

      when(() => repo.signInWithEmail(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => Result.error('FirebaseAuthException: wrong-password'));

      await notifier.submit();

      expect(notifier.state.isSubmitting, isFalse);
      expect(notifier.state.passwordError, contains('パスワード')); // _mapAuthErrorの期待文言に合わせて
    });
  });
}

