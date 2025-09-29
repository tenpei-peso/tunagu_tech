// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../component/app_button.dart';
import '../../../component/auth_text_field.dart';

// Package imports:

class SignUpFormScreen extends ConsumerWidget {
  const SignUpFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'はじめまして👋',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 42,
          ),
          _NameField(),
          SizedBox(
            height: 16,
          ),
          _EmailField(),
          SizedBox(
            height: 16,
          ),
          _PasswordField(),
          SizedBox(
            height: 24,
          ),
          _SignUpButton(),
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

class _NameField extends ConsumerWidget {
  const _NameField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthTextField(
      hintText: 'Name',
      labelText: 'Name',
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

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
        title: '新規会員登録',
        titleStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold),
        onPressed: () {});
  }
}
