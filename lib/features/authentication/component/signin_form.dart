// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../component/app_button.dart';
import '../../../component/auth_text_field.dart';

class SignInForm extends ConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'おかえりなさい👋',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(
            height: 32,
          ),
          const _EmailField(),
          const SizedBox(
            height: 16,
          ),
          const _PasswordField(),
          const _ForgotPasswordButton(),
          const SizedBox(
            height: 24,
          ),
          const _SignInButton(),
        ],
      );
}

class _EmailField extends ConsumerWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthTextField(
      hintText: 'Email',
      labelText: 'Email',
      showValidationSuccessIcon: true,
    );
  }
}

class _PasswordField extends ConsumerWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthTextField(
      hintText: 'Password',
      labelText: 'Password',
      obscureText: true,
      enableObscureToggle: true,
      showValidationSuccessIcon: true,
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'パスワードをお忘れの方',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
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
    return AppButton(
      title: 'ログイン',
      titleStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
      onPressed: () {},
    );
  }
}
