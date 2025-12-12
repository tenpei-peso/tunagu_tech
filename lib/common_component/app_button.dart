// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../theme/Tunagu_colors.dart';

enum AppButtonVariant { filled, outlined, text }

enum AppButtonColor {
  primary, // bg: primary
  alternate, // bg: gray-600
  gray, // bg: gray-100
  red, //bg: red
  blue200, // bg: blue-200
}

enum AppButtonSize { large, medium, small, extraSmall }

extension AppButtonColorExtension on AppButtonColor {
  Color tintColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case AppButtonColor.primary:
        return colorScheme.primary;
      case AppButtonColor.alternate:
        return TunaguColors.gray600;
      case AppButtonColor.gray:
        return TunaguColors.gray100;
      case AppButtonColor.red:
        return TunaguColors.red;
      case AppButtonColor.blue200:
        return TunaguColors.blue200;
    }
  }

  Color backgroundColor(BuildContext context, AppButtonVariant variant) {
    final color = tintColor(context);
    switch (variant) {
      case AppButtonVariant.filled:
        return color;
      case AppButtonVariant.outlined:
        return Colors.transparent;
      case AppButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color foregroundColor(BuildContext context, AppButtonVariant variant) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = tintColor(context);
    switch (variant) {
      case AppButtonVariant.filled:
        if (this == AppButtonColor.gray) {
          return colorScheme.onSurface;
        }
        return colorScheme.onPrimary;
      case AppButtonVariant.outlined:
        return color;
      case AppButtonVariant.text:
        return color;
    }
  }
}

extension AppButtonSizeExtension on AppButtonSize {
  double get height {
    switch (this) {
      case AppButtonSize.extraSmall:
        return 32.0;
      case AppButtonSize.small:
        return 36.0;
      case AppButtonSize.medium:
        return 40.0;
      case AppButtonSize.large:
        return 48.0;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    switch (this) {
      case AppButtonSize.extraSmall:
        return textTheme.labelSmall ?? const TextStyle();
      case AppButtonSize.small:
        return textTheme.labelLarge ?? const TextStyle();
      case AppButtonSize.medium:
        return textTheme.bodySmall ?? const TextStyle();
      case AppButtonSize.large:
        return textTheme.bodySmall ?? const TextStyle();
    }
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.variant = AppButtonVariant.filled,
    this.color = AppButtonColor.primary,
    this.isLoading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.size = AppButtonSize.large,
    this.titleStyle,
  });

  final VoidCallback? onPressed;
  final String title;
  final Widget? icon;
  final AppButtonVariant variant;
  final AppButtonColor color;
  final ValueNotifier<bool>? isLoading;
  final EdgeInsetsGeometry padding;
  final AppButtonSize size;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = color.foregroundColor(context, variant);
    final backgroundColor = color.backgroundColor(context, variant);
    final buttonHeight = size.height;
    final defaultStyle = size.getTextStyle(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading ?? ValueNotifier(false),
      builder: (context, loading, child) {
        final style = ButtonStyle(
          shape: variant == AppButtonVariant.outlined
              ? WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: foregroundColor,
                    ),
                  ),
                )
              : WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          padding: WidgetStateProperty.all(padding),
          elevation: WidgetStateProperty.all(0),
          splashFactory: NoSplash.splashFactory,
          textStyle: titleStyle != null
              ? WidgetStateProperty.all(titleStyle)
              : WidgetStateProperty.all(defaultStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                )),
          iconColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return foregroundColor.withOpacity(0.7);
            }
            return foregroundColor;
          }),
          backgroundColor: WidgetStateProperty.all(
            loading ? Theme.of(context).disabledColor : backgroundColor,
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return foregroundColor.withOpacity(0.7);
            }
            return foregroundColor;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return Colors.transparent; // Defer to the widget's default.
          }),
        );

        if (icon == null) {
          return SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(title),
            ),
          );
        }

        return SizedBox(
          height: buttonHeight,
          child: ElevatedButton.icon(
            style: style,
            onPressed: onPressed,
            icon: icon!,
            label: Text(title),
          ),
        );
      },
    );
  }
}
