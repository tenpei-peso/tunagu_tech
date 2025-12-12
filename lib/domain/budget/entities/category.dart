// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Category for expenses/income. Defaults use TunaguColors and Material Symbols.
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String bookId,
    required String name,
    required String iconName,
    required int colorValue,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  const Category._();

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
