// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_form_state.freezed.dart';

@freezed
abstract class SignUpFormState with _$SignUpFormState {
  const factory SignUpFormState({
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmError,
    String? nameError,
    @Default(false) bool isSubmitting,
    @Default(false) bool isValid,
  }) = _SignUpFormState;

  const SignUpFormState._();
}
