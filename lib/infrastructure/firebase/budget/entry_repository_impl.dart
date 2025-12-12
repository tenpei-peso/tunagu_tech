// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/entry.dart';
import '../../../domain/budget/repositories/entry_repository.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  return FirestoreEntryRepository(firestore);
});

class FirestoreEntryRepository implements EntryRepository {
  FirestoreEntryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('entries');

  @override
  Future<Result<void>> upsertEntry(Entry entry) async {
    try {
      await _entries.doc(entry.id).set(
            entryToDoc(entry),
            SetOptions(merge: true),
          );
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to save entry: $e');
    }
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    try {
      await _entries.doc(id).delete();
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete entry: $e');
    }
  }

  @override
  Stream<Result<List<Entry>>> watchEntriesByMonth({
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
    return _mapEntrySnapshots(query);
  }

  @override
  Stream<Result<List<Entry>>> watchEntriesByDay({
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
    return _mapEntrySnapshots(query);
  }

  Stream<Result<List<Entry>>> _mapEntrySnapshots(
    Query<Map<String, dynamic>> query,
  ) {
    return query.snapshots().transform(
          StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, Result<List<Entry>>>.fromHandlers(
            handleData: (snapshot, sink) {
              try {
                final entries =
                    snapshot.docs.map(entryFromDoc).toList(growable: false);
                sink.add(Result.success(entries));
              } catch (e) {
                sink.add(Result.error('Failed to parse entries: $e'));
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.add(Result.error('Failed to watch entries: $error'));
            },
          ),
        );
  }
}
