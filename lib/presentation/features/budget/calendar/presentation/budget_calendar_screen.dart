// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../../../domain/budget/entities/entry.dart';
import '../../provider/budget_providers.dart';

class BudgetCalendarScreen extends HookConsumerWidget {
  const BudgetCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesByMonthProvider);
    final month = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    final prev = DateTime(month.year, month.month - 1);
                    ref.read(selectedMonthProvider.notifier).state = prev;
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text('${month.year}年${month.month}月'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final next = DateTime(month.year, month.month + 1);
                    ref.read(selectedMonthProvider.notifier).state = next;
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: entries.when(
                data: (list) {
                  final byDay = <int, List<Entry>>{};
                  for (final entry in list) {
                    byDay.putIfAbsent(entry.dateTime.day, () => <Entry>[]).add(entry);
                  }
                  if (byDay.isEmpty) {
                    return const Center(child: Text('この月の記録がありません'));
                  }
                  final sortedDays = byDay.keys.toList()..sort();
                  return ListView.builder(
                    itemCount: sortedDays.length,
                    itemBuilder: (context, index) {
                      final day = sortedDays[index];
                      final dayEntries = byDay[day]!;
                      final total = dayEntries.fold<int>(
                        0,
                        (sum, e) => sum + e.amount,
                      );
                      return ExpansionTile(
                        title: Text('$day 日  合計: $total 円'),
                        children: dayEntries
                            .map(
                              (e) => ListTile(
                                dense: true,
                                title: Text('${e.amount} 円'),
                                subtitle: Text(e.categoryId),
                                trailing: e.memo != null
                                    ? Text(
                                        e.memo!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                              ),
                            )
                            .toList(),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('取得エラー: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
