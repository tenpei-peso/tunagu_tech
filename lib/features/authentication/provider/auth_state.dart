import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated({
    @Default(false) bool loading,
  }) = _Unauthenticated;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.authenticated({
    required User user, // FirebaseAuth.User
  }) = _Authenticated;

  const factory AuthState.failure({
    required String message,
  }) = _Failure;
}