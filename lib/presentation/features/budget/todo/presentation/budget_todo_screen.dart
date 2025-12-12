// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../provider/budget_providers.dart';
import '../../../../../domain/budget/entities/todo.dart';
import '../../../../../infrastructure/firebase/budget/todo_repository_impl.dart';

class BudgetTodoScreen extends HookConsumerWidget {
  const BudgetTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    final categories = ref.watch(categoriesProvider);
    final bookId = ref.watch(selectedHouseholdIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (bookId == null) {
            return;
          }
          final categoryList = categories.value ?? [];
          final categoryId =
              categoryList.isNotEmpty ? categoryList.first.id : 'uncategorized';
          final now = DateTime.now();
          final todo = Todo(
            id: '',
            bookId: bookId,
            categoryId: categoryId,
            title: '新しいTODO',
            dueDate: DateTime(now.year, now.month, now.day + 1),
            status: TodoStatus.incomplete,
            createdAt: now,
            updatedAt: now,
          );
          await ref.read(todoRepositoryProvider).create(todo);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: todos.when(
          data: (list) {
            if (bookId == null) {
              return const Text('家計簿を選択してください');
            }
            if (list.isEmpty) {
              return const Text('TODO はありません');
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final todo = list[index];
                final checked = todo.status == TodoStatus.complete;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      checked ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: checked ? Colors.green : Colors.grey,
                    ),
                    title: Text(todo.title),
                    subtitle: Text('期限: ${todo.dueDate.toLocal().toString().split(' ')[0]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ref.read(todoRepositoryProvider).delete(todo.id);
                      },
                    ),
                    onTap: () async {
                      final updated = todo.copyWith(
                        status: checked
                            ? TodoStatus.incomplete
                            : TodoStatus.complete,
                        updatedAt: DateTime.now(),
                      );
                      await ref.read(todoRepositoryProvider).update(updated);
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('取得エラー: $err'),
        ),
      ),
    );
  }
}
