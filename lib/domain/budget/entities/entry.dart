// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

enum EntryType {
  income,
  expense,
}

@freezed
abstract class Entry with _$Entry {
  const factory Entry({
    required String id,
    required String bookId,
    required EntryType type,
    required int amount,
    required DateTime dateTime,
    required String categoryId,
    @Default(<String>[]) List<String> tagIds,
    String? purchaseTagId,
    String? memo,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Entry;

  const Entry._();

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}
