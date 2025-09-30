// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../features/authentication/component/size_fade_switcher.dart';
import '../theme/Tunagu_colors.dart';
import '../theme/Tunagu_text_theme.dart';

class AuthTextField extends HookConsumerWidget {
  const AuthTextField({
    required this.labelText,
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.enableObscureToggle = false,
    this.showValidationSuccessIcon = false,
    this.showValidationHint = false,
    this.onChanged, 
    this.initialText,
  });

  final String labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool enableObscureToggle;
  final bool showValidationSuccessIcon;
  final bool showValidationHint;
  final ValueChanged<String>? onChanged;
  final String? initialText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscureText = useState(this.obscureText);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText == null ? TunaguColors.gray300 : TunaguColors.red400,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText.value,
            style: const TextStyle(
              fontSize: 16,
              height: 1.2,
              color: TunaguColors.gray900,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              labelText: labelText,
              labelStyle: TunaguTextTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: TunaguColors.gray300,
              ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TunaguTextTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: TunaguColors.gray500,
                height: 1.7,
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  enableObscureToggle
                      ? TextButton(
                          onPressed: () => obscureText.value = !obscureText.value,
                          child: Text(
                            obscureText.value ? '表示' : '非表示',
                            style: TunaguTextTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: TunaguColors.gray300,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  showValidationSuccessIcon
                      ? const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Symbols.check_circle, color: TunaguColors.green400),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        SizeFadeSwitcher(
          child: errorText == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    errorText!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
        ),
      ],
    );
  }
}
