import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_in_form_state.freezed.dart';

  @freezed
abstract class SignInFormState with _$SignInFormState {
  
  const factory SignInFormState({
    @Default('') String email,
    @Default('') String password,
    String? emailError,
    String? passwordError,
    @Default(false) bool isSubmitting,
    @Default(false) bool isValid,
  }) = _SignInFormState;

  const SignInFormState._();
}