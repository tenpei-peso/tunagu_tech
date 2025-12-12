// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_summary.freezed.dart';
part 'monthly_summary.g.dart';

/// Aggregated values for a specific month, supporting charts and home totals.
@freezed
abstract class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required String bookId,
    required DateTime month,
    required int incomeTotal,
    required int expenseTotal,
    required Map<String, int> categoryTotals,
    required Map<String, int> tagTotals,
  }) = _MonthlySummary;

  const MonthlySummary._();

  factory MonthlySummary.fromJson(Map<String, dynamic> json) =>
      _$MonthlySummaryFromJson(json);
}
