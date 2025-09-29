// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../component/auth_switch_button.dart';
import '../component/signin_form.dart';
import '../component/signup_form.dart';
import '../component/slide_fade_switcher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showSignIn = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: SlideFadeSwitcher(
                        child: _showSignIn
                            ? const SignInForm()
                            : const SignUpForm()),
                  ),
                ],
              ),
              Column(
                children: [
                  const Spacer(),
                  AuthSwitchButton(
                    showSignIn: _showSignIn,
                    onTap: () {
                      setState(() {
                        _showSignIn = !_showSignIn;
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
}
