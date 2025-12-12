// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../../domain/budget/entities/category.dart';
import '../../../../domain/budget/entities/entry.dart';
import '../../../../domain/budget/entities/household.dart';
import '../../../../domain/budget/entities/monthly_summary.dart';
import '../../../../domain/budget/entities/tag.dart';
import '../../../../domain/budget/entities/todo.dart';
import '../../../../utility/result.dart';
import '../../../features/authentication/provider/auth_state_provider.dart';
import '../../../../infrastructure/firebase/budget/category_repository_impl.dart';
import '../../../../infrastructure/firebase/budget/entry_repository_impl.dart';
import '../../../../infrastructure/firebase/budget/household_repository_impl.dart';
import '../../../../infrastructure/firebase/budget/summary_repository_impl.dart';
import '../../../../infrastructure/firebase/budget/tag_repository_impl.dart';
import '../../../../infrastructure/firebase/budget/todo_repository_impl.dart';
import '../../authentication/provider/auth_state.dart';

final selectedHouseholdIdProvider = StateProvider<String?>((ref) => null);

final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);

Stream<T> _unwrapResultStream<T>(Stream<Result<T>> stream) {
  return stream.map((result) {
    if (result.isSuccess) {
      return result.data as T;
    }
    throw Exception(result.error);
  });
}

final householdListProvider =
    StreamProvider.autoDispose<List<Household>>((ref) {
  final auth = ref.watch(authNotifierProvider);
  return auth.when<Stream<List<Household>>>(
    authenticated: (user) {
      final repo = ref.watch(householdRepositoryProvider);
      return _unwrapResultStream(repo.watchHouseholds(user.uid));
    },
    loading: () => Stream<List<Household>>.value(<Household>[]),
    failure: (_) => Stream<List<Household>>.value(<Household>[]),
    unauthenticated: (_) => Stream<List<Household>>.value(<Household>[]),
  );
});

final categoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  final bookId = ref.watch(selectedHouseholdIdProvider);
  if (bookId == null) {
    return Stream<List<Category>>.value(<Category>[]);
  }
  final repo = ref.watch(categoryRepositoryProvider);
  return _unwrapResultStream(repo.watchCategories(bookId: bookId));
});

final tagsProvider = StreamProvider.autoDispose<List<Tag>>((ref) {
  final bookId = ref.watch(selectedHouseholdIdProvider);
  if (bookId == null) {
    return Stream<List<Tag>>.value(<Tag>[]);
  }
  final repo = ref.watch(tagRepositoryProvider);
  return _unwrapResultStream(repo.watchTags(bookId: bookId));
});

final entriesByMonthProvider = StreamProvider.autoDispose<List<Entry>>((ref) {
  final bookId = ref.watch(selectedHouseholdIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (bookId == null) {
    return Stream<List<Entry>>.value(<Entry>[]);
  }
  final repo = ref.watch(entryRepositoryProvider);
  return _unwrapResultStream(
    repo.watchEntriesByMonth(bookId: bookId, month: month),
  );
});

final monthlySummaryProvider =
    StreamProvider.autoDispose<MonthlySummary>((ref) {
  final bookId = ref.watch(selectedHouseholdIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (bookId == null) {
    return Stream<MonthlySummary>.value(
      MonthlySummary(
        bookId: '',
        month: month,
        incomeTotal: 0,
        expenseTotal: 0,
        categoryTotals: const {},
        tagTotals: const {},
      ),
    );
  }
  final repo = ref.watch(summaryRepositoryProvider);
  return _unwrapResultStream(
    repo.watchMonthlySummary(bookId: bookId, month: month),
  );
});

final todosProvider = StreamProvider.autoDispose<List<Todo>>((ref) {
  final bookId = ref.watch(selectedHouseholdIdProvider);
  if (bookId == null) {
    return Stream<List<Todo>>.value(<Todo>[]);
  }
  final repo = ref.watch(todoRepositoryProvider);
  return _unwrapResultStream(repo.watchAll(bookId));
});
