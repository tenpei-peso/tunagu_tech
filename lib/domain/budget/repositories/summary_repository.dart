import '../../../utility/result.dart';
import '../entities/entry.dart';
import '../entities/monthly_summary.dart';

abstract class SummaryRepository {
  /// Returns monthly aggregate used by home and graph screens.
  Stream<Result<MonthlySummary>> watchMonthlySummary({
    required String bookId,
    required DateTime month,
  });

  /// Returns entries already grouped for a specific day (calendar detail).
  Stream<Result<List<Entry>>> watchDailyEntries({
    required String bookId,
    required DateTime day,
  });
}
