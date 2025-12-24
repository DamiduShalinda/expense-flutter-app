import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/dashboard_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';
import 'package:expense_manage/ui/widgets/analytics_bar_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  _DashboardPeriod _period = _DashboardPeriod.week;
  DateTimeRange? _customRange;

  @override
  Widget build(BuildContext context) {
    final weekday = ref.watch(firstDayOfWeekProvider).value ?? DateTime.monday;
    final range = _resolveRange(weekday);
    final dashboardAsync = ref.watch(
      dashboardProvider(DashboardQuery(start: range.start, end: range.end)),
    );
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
        _buildPeriodSelector(context),
        const SizedBox(height: 12),
        dashboardAsync.when(
          data: (state) => _PeriodSummaryCard(
            title: _periodLabel(),
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
                      'Net per day',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    AnalyticsBarChart(
                      values: values,
                      labels: _dayLabels(state.start, values.length),
                    ),
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
                  return const Text('No expenses this period');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Expenses by category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    AnalyticsBarChart(
                      values:
                          items.map((e) => e.totalExpense.toDouble()).toList(),
                      labels:
                          items
                              .map(
                                (e) => _shortLabel(
                                  _categoryName(e.categoryId, categoriesById),
                                ),
                              )
                              .toList(),
                      positiveColor: Theme.of(context).colorScheme.primary,
                      negativeColor: Theme.of(context).colorScheme.primary,
                      zeroColor: Theme.of(context).colorScheme.primary,
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
        dashboardAsync.when(
          data: (state) {
            if (state.topExpenseNotes.isEmpty) {
              return const SizedBox.shrink();
            }
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Top notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    for (final note in state.topExpenseNotes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text(note.note)),
                            AmountText(
                              -note.totalExpense,
                              currencyCode: currencyCode,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
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

class _PeriodSummaryCard extends StatelessWidget {
  const _PeriodSummaryCard({
    required this.title,
    required this.start,
    required this.end,
    required this.income,
    required this.expense,
    required this.net,
    required this.currencyCode,
  });

  final String title;
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
            Text(title, style: Theme.of(context).textTheme.titleMedium),
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

String _shortLabel(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return 'N/A';
  if (trimmed.length <= 6) return trimmed;
  return trimmed.substring(0, 6);
}

List<String> _dayLabels(DateTime start, int days) {
  const labels = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final startDay = DateTime(start.year, start.month, start.day);
  return List<String>.generate(days, (index) {
    final day = startDay.add(Duration(days: index));
    return labels[day.weekday - 1];
  });
}

enum _DashboardPeriod { week, month, custom }

extension on _DashboardScreenState {
  Widget _buildPeriodSelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Week'),
          selected: _period == _DashboardPeriod.week,
          onSelected: (_) => setState(() => _period = _DashboardPeriod.week),
        ),
        ChoiceChip(
          label: const Text('Month'),
          selected: _period == _DashboardPeriod.month,
          onSelected: (_) => setState(() => _period = _DashboardPeriod.month),
        ),
        ChoiceChip(
          label: const Text('Custom'),
          selected: _period == _DashboardPeriod.custom,
          onSelected: (_) => _pickCustomRange(context),
        ),
      ],
    );
  }

  DateTimeRange _resolveRange(int firstDayOfWeek) {
    final now = DateTime.now();
    return switch (_period) {
      _DashboardPeriod.week => DateTimeRange(
        start: startOfWeek(now, firstDayOfWeek: firstDayOfWeek),
        end: startOfWeek(now, firstDayOfWeek: firstDayOfWeek).add(
          const Duration(days: 7),
        ),
      ),
      _DashboardPeriod.month => DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 1),
      ),
      _DashboardPeriod.custom =>
        _customRange ??
            DateTimeRange(
              start: startOfWeek(now, firstDayOfWeek: firstDayOfWeek),
              end: startOfWeek(now, firstDayOfWeek: firstDayOfWeek).add(
                const Duration(days: 7),
              ),
            ),
    };
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final initial = _customRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initial,
    );
    if (!mounted) return;
    if (picked == null) return;
    setState(() {
      _period = _DashboardPeriod.custom;
      _customRange = DateTimeRange(
        start: DateTime(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        ),
        end: DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
        ).add(const Duration(days: 1)),
      );
    });
  }

  String _periodLabel() {
    return switch (_period) {
      _DashboardPeriod.week => 'This week',
      _DashboardPeriod.month => 'This month',
      _DashboardPeriod.custom => 'Custom range',
    };
  }
}
