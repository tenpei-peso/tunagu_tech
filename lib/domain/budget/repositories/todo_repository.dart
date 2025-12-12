import '../../../utility/result.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Result<Todo>> create(Todo todo);

  Future<Result<Todo>> update(Todo todo);

  Future<Result<void>> delete(String id);

  Stream<Result<List<Todo>>> watchAll(String bookId);
}
