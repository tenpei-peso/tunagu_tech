// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'household.freezed.dart';
part 'household.g.dart';

/// Household/Book represents a shared budget space.
@freezed
abstract class Household with _$Household {
  const factory Household({
    required String id,
    required String name,
    required List<String> memberIds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Household;

  const Household._();

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
}
