// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_user_state.freezed.dart';
part 'firestore_user_state.g.dart';

@freezed
abstract class FirestoreUserState with _$FirestoreUserState {
  factory FirestoreUserState({
    required String uid,
    required String displayName,
    required dynamic createdAt,
    required dynamic updatedAt,
  }) = _FirestoreUserState;
  const FirestoreUserState._();

  factory FirestoreUserState.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserStateFromJson(json);
}
