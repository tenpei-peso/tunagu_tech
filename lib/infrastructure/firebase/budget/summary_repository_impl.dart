// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/entry.dart';
import '../../../domain/budget/entities/monthly_summary.dart';
import '../../../domain/budget/repositories/summary_repository.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final summaryRepositoryProvider = Provider<SummaryRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  return FirestoreSummaryRepository(firestore);
});

class FirestoreSummaryRepository implements SummaryRepository {
  FirestoreSummaryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('entries');

  @override
  Stream<Result<MonthlySummary>> watchMonthlySummary({
    required String bookId,
    required DateTime month,
  }) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final query = _entries
        .where('bookId', isEqualTo: bookId)
        .where('dateTime', isGreaterThanOrEqualTo: start)
        .where('dateTime', isLessThan: end)
        .orderBy('dateTime');
    return query.snapshots().transform(
      StreamTransformer<
          QuerySnapshot<Map<String, dynamic>>, Result<MonthlySummary>>.fromHandlers(
        handleData: (snapshot, sink) {
          try {
            final entries = snapshot.docs.map(entryFromDoc).toList();
            final summary = _buildSummary(bookId, start, entries);
            sink.add(Result.success(summary));
          } catch (e) {
            sink.add(Result.error('Failed to parse monthly summary: $e'));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(Result.error('Failed to watch monthly summary: $error'));
        },
      ),
    );
  }

  @override
  Stream<Result<List<Entry>>> watchDailyEntries({
    required String bookId,
    required DateTime day,
  }) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final query = _entries
        .where('bookId', isEqualTo: bookId)
        .where('dateTime', isGreaterThanOrEqualTo: start)
        .where('dateTime', isLessThan: end)
        .orderBy('dateTime');
    return query.snapshots().transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, Result<List<Entry>>>.
          fromHandlers(
        handleData: (snapshot, sink) {
          try {
            final entries =
                snapshot.docs.map(entryFromDoc).toList(growable: false);
            sink.add(Result.success(entries));
          } catch (e) {
            sink.add(Result.error('Failed to parse daily entries: $e'));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(Result.error('Failed to watch daily entries: $error'));
        },
      ),
    );
  }

  MonthlySummary _buildSummary(
    String bookId,
    DateTime month,
    List<Entry> entries,
  ) {
    var incomeTotal = 0;
    var expenseTotal = 0;
    final categoryTotals = <String, int>{};
    final tagTotals = <String, int>{};

    for (final entry in entries) {
      if (entry.type == EntryType.income) {
        incomeTotal += entry.amount;
      } else {
        expenseTotal += entry.amount;
      }
      categoryTotals.update(
        entry.categoryId,
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount,
      );

      final tags = <String>[...entry.tagIds];
      if (entry.purchaseTagId != null) {
        tags.add(entry.purchaseTagId!);
      }
      for (final tagId in tags) {
        tagTotals.update(
          tagId,
          (value) => value + entry.amount,
          ifAbsent: () => entry.amount,
        );
      }
    }

    return MonthlySummary(
      bookId: bookId,
      month: month,
      incomeTotal: incomeTotal,
      expenseTotal: expenseTotal,
      categoryTotals: categoryTotals,
      tagTotals: tagTotals,
    );
  }
}
