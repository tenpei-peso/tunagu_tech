// Flutter

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../../common_component/app_button.dart';
import '../../../../common_component/auth_text_field.dart';
import '../provider/sign_in_form_state_provider.dart';

// Riverpod

// Project imports

class SigninFormScreen extends ConsumerWidget {
  const SigninFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Title(),
          SizedBox(height: 32),
          _EmailField(),
          SizedBox(height: 16),
          _PasswordField(),
          _ForgotPasswordButton(),
          SizedBox(height: 24),
          _SignInButton(),
        ],
      );
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) => Text(
        'おかえりなさい👋',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
}

class _EmailField extends ConsumerWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signInFormProvider);
    final notifier = ref.read(signInFormProvider.notifier);

    return AuthTextField(
      hintText: 'Email',
      labelText: 'Email',
      initialText: form.email,
      errorText: form.emailError,
      showValidationSuccessIcon:
          form.email.isNotEmpty && form.emailError == null,
      onChanged: notifier.setEmail,
    );
  }
}

class _PasswordField extends ConsumerWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signInFormProvider);
    final notifier = ref.read(signInFormProvider.notifier);

    return AuthTextField(
      hintText: 'Password',
      labelText: 'Password',
      initialText: form.password,
      errorText: form.passwordError,
      obscureText: true,
      enableObscureToggle: true,
      showValidationSuccessIcon:
          form.password.isNotEmpty && form.passwordError == null,
      onChanged: notifier.setPassword,
    );
  }
}

class _ForgotPasswordButton extends ConsumerWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // パスワードリセット遷移 or 処理をここで
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, '/forgot-password'); など
          },
          child: Text(
            'パスワードをお忘れの方',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends ConsumerWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signInFormProvider);
    final notifier = ref.read(signInFormProvider.notifier);

    return AppButton(
      title: form.isSubmitting ? 'ログイン中…' : 'ログイン',
      titleStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
      onPressed: (form.isValid && !form.isSubmitting) ? notifier.submit : null,
    );
  }
}
