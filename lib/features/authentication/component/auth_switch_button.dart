// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../component/app_button.dart';
import '../../../theme/Tunagu_colors.dart';
import 'slide_fade_switcher.dart';

class AuthSwitchButton extends StatelessWidget {
  final bool showSignIn;
  final VoidCallback onTap;
  const AuthSwitchButton({
    super.key,
    required this.showSignIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: TunaguColors.gray600,
    );
    return SlideFadeSwitcher(
      child: showSignIn
          ? Padding(
              key: const ValueKey('SignIn'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'はじめての利用ですか？',
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    title: '新規会員登録',
                    color: AppButtonColor.alternate,
                    variant: AppButtonVariant.outlined,
                    onPressed: onTap,
                  )
                ],
              ),
            )
          : Padding(
              key: const ValueKey('SignUp'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'すでにアカウントをお持ちの方',
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    title: 'ログイン',
                    variant: AppButtonVariant.outlined,
                    color: AppButtonColor.alternate,
                    onPressed: onTap,
                  )
                ],
              ),
            ),
    );
  }
}
