// Flutter imports:
import 'package:flutter/material.dart';

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.failure,
    required this.onFailure,
    required this.failureContainer,
    required this.onFailureContainer,
  });

  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;
  final Color? failure;
  final Color? onFailure;
  final Color? failureContainer;
  final Color? onFailureContainer;

  @override
  SemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? failure,
    Color? onFailure,
    Color? failureContainer,
    Color? onFailureContainer,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      failure: failure ?? this.failure,
      onFailure: onFailure ?? this.onFailure,
      failureContainer: failureContainer ?? this.failureContainer,
      onFailureContainer: onFailureContainer ?? this.onFailureContainer,
    );
  }

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) {
      return this;
    }
    return SemanticColors(
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
      failure: Color.lerp(failure, other.failure, t),
      onFailure: Color.lerp(onFailure, other.onFailure, t),
      failureContainer: Color.lerp(failureContainer, other.failureContainer, t),
      onFailureContainer:
          Color.lerp(onFailureContainer, other.onFailureContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  SemanticColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }

  static SemanticColors lightColors = const SemanticColors(
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFF0FDF4),
    onSuccessContainer: Color(0xFF012d0e),
    failure: Color(0xFFFF3A36),
    onFailure: Color(0xFFFFFFFF),
    failureContainer: Color(0xFFFFB3B3),
    onFailureContainer: Color(0xFFFF0800),
  );

  static SemanticColors darkColors = const SemanticColors(
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFF0FDF4),
    onSuccessContainer: Color(0xFF012d0e),
    failure: Color(0xFFFF3A36),
    onFailure: Color(0xFFFFFFFF),
    failureContainer: Color(0xFFFFB3B3),
    onFailureContainer: Color(0xFFFF0800),
  );
}
