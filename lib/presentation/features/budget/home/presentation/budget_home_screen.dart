// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../../../theme/Tunagu_colors.dart';
import '../../../../../domain/budget/entities/entry.dart';
import '../../provider/budget_providers.dart';

class BudgetHomeScreen extends HookConsumerWidget {
  const BudgetHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final households = ref.watch(householdListProvider);
    final selectedHousehold = ref.watch(selectedHouseholdIdProvider);
    final month = ref.watch(selectedMonthProvider);
    final summary = ref.watch(monthlySummaryProvider);
    final entries = ref.watch(entriesByMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          households.when(
            data: (data) {
              if (selectedHousehold == null && data.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(selectedHouseholdIdProvider.notifier).state =
                      data.first.id;
                });
              }
              return DropdownButton<String?>(
                value: selectedHousehold ?? (data.isEmpty ? null : data.first.id),
                hint: const Text('家計簿を選択'),
                items: data
                    .map(
                      (h) => DropdownMenuItem(
                        value: h.id,
                        child: Text(h.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(selectedHouseholdIdProvider.notifier).state = value;
                },
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('読み込みエラー: $err'),
          ),
          const SizedBox(height: 8),
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
                  child: Text(
                    '${month.year}年${month.month}月',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
          summary.when(
            data: (data) => Card(
              color: TunaguColors.gray100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('収入: ${data.incomeTotal} 円'),
                    Text('支出: ${data.expenseTotal} 円'),
                    Text('差額: ${data.incomeTotal - data.expenseTotal} 円'),
                  ],
                ),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('サマリ取得エラー: $err'),
          ),
          const SizedBox(height: 16),
          Text(
            '今月の記録',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          entries.when(
            data: (list) {
              if (selectedHousehold == null) {
                return const Text('家計簿を選択してください');
              }
              if (list.isEmpty) {
                return const Text('この月のデータはありません');
              }
              return Column(
                children: list
                    .map(
                      (e) => ListTile(
                        leading: Icon(
                          e.type == EntryType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: e.type == EntryType.income
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text('${e.amount} 円'),
                        subtitle: Text(
                          '${e.dateTime.day}日  ${e.categoryId}',
                        ),
                        trailing: e.memo != null ? Text(e.memo!) : null,
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('取得エラー: $err'),
          ),
        ],
      ),
    );
  }
}
