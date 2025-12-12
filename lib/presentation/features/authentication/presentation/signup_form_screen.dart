// Flutter

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../../common_component/app_button.dart';
import '../../../../common_component/auth_text_field.dart';
import '../provider/sign_up_form_state_provider.dart';

// Riverpod

// Project imports

class SignUpFormScreen extends ConsumerWidget {
  const SignUpFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Title(),
          SizedBox(height: 40),
          SizedBox(height: 42),
          _NameField(),
          SizedBox(height: 16),
          _EmailField(),
          SizedBox(height: 16),
          _PasswordField(),
          SizedBox(height: 16),
          _SignUpButton(),
        ],
      );
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) => Text(
        'はじめまして👋',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
}

class _NameField extends ConsumerWidget {
  const _NameField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signUpFormProvider);
    final notifier = ref.read(signUpFormProvider.notifier);

    return AuthTextField(
      labelText: 'Name',
      hintText: '山田 太郎',
      initialText: form.name,
      errorText: form.nameError,
      showValidationSuccessIcon:
          (form.name.isNotEmpty) && form.nameError == null,
      onChanged: notifier.setName,
    );
  }
}

class _EmailField extends ConsumerWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signUpFormProvider);
    final notifier = ref.read(signUpFormProvider.notifier);

    return AuthTextField(
      labelText: 'Email',
      hintText: 'you@example.com',
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
    final form = ref.watch(signUpFormProvider);
    final notifier = ref.read(signUpFormProvider.notifier);

    return AuthTextField(
      labelText: 'Password',
      hintText: '6文字以上',
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

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(signUpFormProvider);
    final notifier = ref.read(signUpFormProvider.notifier);

    return AppButton(
      title: form.isSubmitting ? '作成中…' : '新規会員登録',
      titleStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
      onPressed: (form.isValid && !form.isSubmitting) ? notifier.submit : null,
    );
  }
}
