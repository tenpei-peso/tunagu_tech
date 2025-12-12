// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/todo.dart';
import '../../../domain/budget/repositories/todo_repository.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  return FirestoreTodoRepository(firestore);
});

class FirestoreTodoRepository implements TodoRepository {
  FirestoreTodoRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _todos =>
      _firestore.collection('todos');

  @override
  Future<Result<Todo>> create(Todo todo) async {
    try {
      final docRef =
          todo.id.isEmpty ? _todos.doc() : _todos.doc(todo.id);
      final created = todo.copyWith(
        id: docRef.id,
        createdAt: todo.createdAt,
        updatedAt: todo.updatedAt,
      );
      await docRef.set(todoToDoc(created));
      return Result.success(created);
    } catch (e) {
      return Result.error('Failed to create todo: $e');
    }
  }

  @override
  Future<Result<Todo>> update(Todo todo) async {
    try {
      await _todos.doc(todo.id).update(todoToDoc(todo));
      return Result.success(todo);
    } catch (e) {
      return Result.error('Failed to update todo: $e');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _todos.doc(id).delete();
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete todo: $e');
    }
  }

  @override
  Stream<Result<List<Todo>>> watchAll(String bookId) {
    return _todos
        .where('bookId', isEqualTo: bookId)
        .orderBy('dueDate')
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, Result<List<Todo>>>.
          fromHandlers(
        handleData: (snapshot, sink) {
          try {
            final todos = snapshot.docs.map(todoFromDoc).toList(growable: false);
            sink.add(Result.success(todos));
          } catch (e) {
            sink.add(Result.error('Failed to parse todos: $e'));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(Result.error('Failed to watch todos: $error'));
        },
      ),
    );
  }
}
