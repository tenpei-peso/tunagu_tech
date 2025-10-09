import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tunagu/domain/repositories/auth_repository.dart';
import 'package:tunagu/features/authentication/provider/sign_up_form_state_provider.dart';
import 'package:tunagu/utility/result.dart';



class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUserCredential extends Fake implements UserCredential {}

Future<void> main() async {
  late MockAuthRepository repo;
  late SignUpFormNotifier notifier;

  setUp(() {
    repo = MockAuthRepository();
    notifier = SignUpFormNotifier(repo);
  });

  group('signUp:バリデーション', () {

    test('名前が空ならエラーを表示', () {
      notifier.setName('');
      expect(notifier.state.nameError, isNotNull);
    });
    
    test('無効なメールアドレスはエラーを表示', () {
      notifier.setEmail('invalid');
      expect(notifier.state.emailError, isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('短いパスワードはエラーを表示', () {
      notifier.setPassword('12345');
      expect(notifier.state.passwordError, isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('有効なメールアドレスとパスワードはisValid=trueを設定', () {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');
      expect(notifier.state.isValid, isTrue);
    });
  });

  group('signUp:submit', () {
    test('成功時はエラーをクリアし、isSubmittingをトグルする', () async {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');

      when(() => repo.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Result.success(FakeUserCredential()));

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

    test('失敗時はエラーメッセージを設定する', () async {
      notifier
        ..setEmail('a@b.com')
        ..setPassword('123456');

      when(() => repo.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer(
        (_) async => Result.error('FirebaseAuthException: email-already-in-use'),
      );

      await notifier.submit();

      expect(notifier.state.isSubmitting, isFalse);
      expect(notifier.state.passwordError, contains('既に使用'));
    });
  });
}
