// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

enum TagType {
  standard,
  purchasePlace,
}

@freezed
class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String bookId,
    required String name,
    required String iconName,
    required int colorValue,
    @Default(TagType.standard) TagType type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Tag;

  const Tag._();

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
