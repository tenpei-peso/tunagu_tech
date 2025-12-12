import '../../../utility/result.dart';
import '../entities/entry.dart';

abstract class EntryRepository {
  Future<Result<void>> upsertEntry(Entry entry);

  Future<Result<void>> deleteEntry(String id);

  Stream<Result<List<Entry>>> watchEntriesByMonth({
    required String bookId,
    required DateTime month,
  });

  Stream<Result<List<Entry>>> watchEntriesByDay({
    required String bookId,
    required DateTime day,
  });
}
