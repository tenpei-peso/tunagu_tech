// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../provider/budget_providers.dart';

final _aggregationAxisProvider = StateProvider<String>((ref) => 'category');

class BudgetGraphScreen extends HookConsumerWidget {
  const BudgetGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(monthlySummaryProvider);
    final categories = ref.watch(categoriesProvider);
    final tags = ref.watch(tagsProvider);
    final axis = ref.watch(_aggregationAxisProvider);

    String resolveLabel(String id) {
      if (axis == 'category') {
        final list = categories.value;
        if (list != null) {
          for (final cat in list) {
            if (cat.id == id) {
              return cat.name;
            }
          }
        }
      } else {
        final list = tags.value;
        if (list != null) {
          for (final tag in list) {
            if (tag.id == id) {
              return tag.name;
            }
          }
        }
      }
      return id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('グラフ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              isSelected: [axis == 'category', axis == 'tag'],
              onPressed: (index) {
                ref.read(_aggregationAxisProvider.notifier).state =
                    index == 0 ? 'category' : 'tag';
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('カテゴリ'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('タグ'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: summary.when(
                data: (data) {
                  final totals =
                      axis == 'category' ? data.categoryTotals : data.tagTotals;
                  if (totals.isEmpty) {
                    return const Center(child: Text('データがありません'));
                  }
                  final entries = totals.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = entries[index];
                      final label = resolveLabel(item.key);
                      return ListTile(
                        title: Text(label),
                        trailing: Text('${item.value} 円'),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('取得エラー: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
