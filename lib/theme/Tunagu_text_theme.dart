import 'package:flutter/material.dart';

TextStyle heading1 = const TextStyle(
  fontSize: 28,
  // height: 28 / 36,
);

TextStyle heading2 = const TextStyle(
  fontSize: 24,
  // height: 24 / 32,
);

TextStyle heading3 = const TextStyle(
  fontSize: 20,
  // height: 20 / 28,
);

TextStyle heading4 = const TextStyle(
  fontSize: 12,
  // height: 12 / 14,
);

TextStyle bodyLarge = const TextStyle(
  fontSize: 18,
  // height: 18 / 26,
);

TextStyle bodyMedium = const TextStyle(
  fontSize: 16,
  // height: 16 / 24,
);

TextStyle bodySmall = const TextStyle(
  fontSize: 14,
  // height: 14 / 20,
);

TextStyle caption = const TextStyle(
  fontSize: 12,
  // height: 12 / 14,
);

TextTheme TunaguTextTheme = TextTheme(
  headlineLarge: heading1,
  headlineMedium: heading2,
  headlineSmall: heading3,
  titleLarge: heading4,
  titleMedium: heading4,
  titleSmall: heading4,
  bodyLarge: bodyLarge,
  bodyMedium: bodyMedium,
  bodySmall: bodySmall,
  labelLarge: caption,
  labelMedium: caption,
  labelSmall: caption,
);
