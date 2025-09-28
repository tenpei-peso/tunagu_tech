import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Tunagu_colors.dart';
import 'Tunagu_text_theme.dart';
import 'semantic_colors.dart';

class TunaguThemes {
  static const lightColors = ColorScheme(
    primary: TunaguColors.primary,
    onPrimary: TunaguColors.white,
    secondary: TunaguColors.secondary,
    onSecondary: TunaguColors.white,
    error: TunaguColors.red,
    onError: TunaguColors.white,
    background: TunaguColors.gray50,
    onBackground: TunaguColors.gray900,
    surface: TunaguColors.gray50,
    onSurface: TunaguColors.gray900,
    brightness: Brightness.light,
  );

  static ThemeData getThemeFromScheme(ColorScheme colorScheme) {
    return ThemeData(
      materialTapTargetSize: MaterialTapTargetSize.padded,
      colorScheme: colorScheme,
      extensions: [SemanticColors.lightColors],
      visualDensity: VisualDensity.standard,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      textTheme: TunaguTextTheme,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: colorScheme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: colorScheme.surface,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark)
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: colorScheme.surface,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Color(0xFF22242A),
        ),
        elevation: 0.01,
      ),
      navigationBarTheme: NavigationBarThemeData(
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
          (states) => (states.contains(MaterialState.selected)
              ? IconThemeData(color: colorScheme.onPrimaryContainer)
              : IconThemeData(color: colorScheme.onSurface)),
        ),
        shadowColor: colorScheme.onBackground,
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: Colors.white,
        // height: 56,
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TunaguTextTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold);
          }
          return TunaguTextTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          );
        }),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
              (states) => (states.contains(MaterialState.selected)
                  ? IconThemeData(color: colorScheme.onPrimaryContainer)
                  : IconThemeData(color: colorScheme.onSurface))),
          shadowColor: colorScheme.onBackground,
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.primaryContainer,
          elevation: 8,
          labelTextStyle: WidgetStateProperty.resolveWith((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500)
                  : null)),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          return colorScheme.onPrimary;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          } else if (states.contains(MaterialState.selected)) {
            return TunaguColors.primary;
          } else {
            return TunaguColors.gray500;
          }
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return Colors.transparent;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? colorScheme.primary
                : null),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((states) {
            return const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            );
          }),
          splashFactory: NoSplash.splashFactory,
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) =>
                TunaguTextTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
          iconColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.primary.withOpacity(0.7);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.primary.withOpacity(0.7);
            }
            return colorScheme.primary;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return Colors.transparent; // Defer to the widget's default.
          }),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? colorScheme.primary
                : null),
      ),
    );
  }
}
