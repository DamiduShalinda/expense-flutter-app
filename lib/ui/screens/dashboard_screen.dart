import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/dashboard_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';
import 'package:expense_manage/ui/widgets/simple_bar_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(weeklyDashboardProvider);
    final accountsAsync = ref.watch(activeAccountsProvider);
    final categoriesAsync = ref.watch(categoriesByParentProvider);
    final currencyCode = ref.watch(currencyCodeProvider).value;

    final categoriesById = categoriesAsync.maybeWhen(
      data: (grouped) {
        final result = <int, Category>{};
        for (final entry in grouped.entries) {
          for (final c in entry.value) {
            result[c.id] = c;
          }
        }
        return result;
      },
      orElse: () => const <int, Category>{},
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        dashboardAsync.when(
          data: (state) => _WeeklySummaryCard(
            start: state.start,
            end: state.end,
            income: state.summary.incomeTotal,
            expense: state.summary.expenseTotal,
            net: state.summary.net,
            currencyCode: currencyCode,
          ),
          error: (error, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Failed to load summary: $error'),
            ),
          ),
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: dashboardAsync.when(
              data: (state) {
                final values = state.dailyIncomeExpense
                    .map((d) => (d.income - d.expense).toDouble())
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Last 7 days',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SimpleBarChart(values: values),
                    const SizedBox(height: 8),
                    Text(
                      'Net per day (income - expense)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
              error: (error, _) => Text('Failed to load chart: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: dashboardAsync.when(
              data: (state) {
                final items = state.topExpenseCategories;
                if (items.isEmpty) {
                  return const Text('No expenses this week');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Top categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    for (final item in items)
                      _CategoryBreakdownRow(
                        name: _categoryName(item.categoryId, categoriesById),
                        color: _categoryColor(item.categoryId, categoriesById),
                        totalExpense: item.totalExpense,
                        percentage: item.percentage,
                        currencyCode: currencyCode,
                      ),
                  ],
                );
              },
              error: (error, _) => Text('Failed to load breakdown: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: accountsAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return const Text('No accounts yet');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Accounts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    for (final a in accounts)
                      _AccountSnapshotRow(
                        account: a,
                        currencyCode: currencyCode,
                      ),
                  ],
                );
              },
              error: (error, _) => Text('Failed to load accounts: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard({
    required this.start,
    required this.end,
    required this.income,
    required this.expense,
    required this.net,
    required this.currencyCode,
  });

  final DateTime start;
  final DateTime end;
  final int income;
  final int expense;
  final int net;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('This week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${_fmtDate(start)} – ${_fmtDate(end.subtract(const Duration(days: 1)))}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Income',
              amount: income,
              currencyCode: currencyCode,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Expense',
              amount: -expense,
              currencyCode: currencyCode,
            ),
            const Divider(height: 24),
            _SummaryRow(label: 'Net', amount: net, currencyCode: currencyCode),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.currencyCode,
  });

  final String label;
  final int amount;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        AmountText(amount, currencyCode: currencyCode),
      ],
    );
  }
}

class _CategoryBreakdownRow extends StatelessWidget {
  const _CategoryBreakdownRow({
    required this.name,
    required this.color,
    required this.totalExpense,
    required this.percentage,
    required this.currencyCode,
  });

  final String name;
  final Color color;
  final int totalExpense;
  final double percentage;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final percentText = '${(percentage * 100).toStringAsFixed(0)}%';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name)),
          Text(percentText, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 12),
          AmountText(-totalExpense, currencyCode: currencyCode),
        ],
      ),
    );
  }
}

class _AccountSnapshotRow extends StatelessWidget {
  const _AccountSnapshotRow({
    required this.account,
    required this.currencyCode,
  });

  final Account account;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final isCreditCard = account.type == AccountType.creditCard;
    final displayBalance = isCreditCard
        ? -account.currentBalance
        : account.currentBalance;

    final utilization =
        isCreditCard && account.creditLimit != null && account.creditLimit! > 0
        ? account.currentBalance / account.creditLimit!
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(account.name)),
              AmountText(displayBalance, currencyCode: currencyCode),
            ],
          ),
          if (utilization != null) ...[
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: utilization.clamp(0.0, 1.0),
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Utilization ${(utilization * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _categoryName(int? categoryId, Map<int, Category> categoriesById) {
  if (categoryId == null) return 'Uncategorized';
  return categoriesById[categoryId]?.name ?? 'Uncategorized';
}

Color _categoryColor(int? categoryId, Map<int, Category> categoriesById) {
  if (categoryId == null) return Colors.grey;
  final raw = categoriesById[categoryId]?.color;
  return raw == null ? Colors.grey : Color(raw);
}

String _fmtDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}
