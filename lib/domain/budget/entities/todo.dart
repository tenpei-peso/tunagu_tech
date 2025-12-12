// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoStatus {
  incomplete,
  complete,
}

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String bookId,
    required String categoryId,
    required String title,
    required DateTime dueDate,
    required bool isDone,
    @Default(TodoStatus.incomplete) TodoStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Todo;

  const Todo._();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
