import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/providers/transactions_provider.dart';
import 'package:expense_manage/ui/screens/transfer_sheet.dart';
import 'package:expense_manage/ui/screens/transaction_sheet.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  late DateTime _rangeStart;
  late DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _rangeStart = DateTime(now.year, now.month, 1);
    _rangeEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
  }

  @override
  Widget build(BuildContext context) {
    final query = TransactionsQuery(start: _rangeStart, end: _rangeEnd);
    final transactionsAsync = ref.watch(transactionsProvider(query));
    final accountsAsync = ref.watch(activeAccountsProvider);
    final categoriesAsync = ref.watch(categoriesByParentProvider);
    final currencyCode = ref.watch(currencyCodeProvider).value;

    final accountsById = accountsAsync.maybeWhen(
      data: (accounts) => {for (final a in accounts) a.id: a},
      orElse: () => const <int, Account>{},
    );

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

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: transactionsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const KeyedSubtree(
                key: ValueKey('tx-empty'),
                child: Center(child: Text('No transactions yet')),
              );
            }

            final groups = _groupByDay(items);
            final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));

            return KeyedSubtree(
              key: const ValueKey('tx-data'),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final dayItems = groups[day]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Text(
                          _formatDay(day),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      for (final tx in dayItems)
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(_titleFor(tx, categoriesById)),
                            subtitle: Text(_subtitleFor(tx, accountsById)),
                            trailing: AmountText(
                              _displayAmount(tx),
                              currencyCode: currencyCode,
                              positiveColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              negativeColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              zeroColor: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
          error: (error, _) => KeyedSubtree(
            key: const ValueKey('tx-error'),
            child: Center(child: Text('Failed to load: $error')),
          ),
          loading: () => const KeyedSubtree(
            key: ValueKey('tx-loading'),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openCreateMenu(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Add transaction'),
                onTap: () {
                  Navigator.pop(context);
                  showAddTransactionSheet(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz_outlined),
                title: const Text('Add transfer'),
                onTap: () {
                  Navigator.pop(context);
                  showAddTransferSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Map<DateTime, List<Transaction>> _groupByDay(List<Transaction> items) {
  final grouped = <DateTime, List<Transaction>>{};
  for (final tx in items) {
    final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
    grouped.putIfAbsent(day, () => []).add(tx);
  }

  for (final entry in grouped.entries) {
    entry.value.sort((a, b) => b.date.compareTo(a.date));
  }

  return grouped;
}

String _titleFor(Transaction tx, Map<int, Category> categoriesById) {
  return switch (tx.type) {
    TransactionType.income =>
      categoriesById[tx.categoryId]?.name ?? 'Uncategorized',
    TransactionType.expense =>
      categoriesById[tx.categoryId]?.name ?? 'Uncategorized',
    TransactionType.transfer => 'Transfer',
  };
}

String _subtitleFor(Transaction tx, Map<int, Account> accountsById) {
  final account = accountsById[tx.accountId];
  final accountLabel = account == null
      ? 'Account #${tx.accountId}'
      : account.name;
  if (tx.note == null || tx.note!.trim().isEmpty) return accountLabel;
  return '$accountLabel • ${tx.note}';
}

int _displayAmount(Transaction tx) {
  return switch (tx.type) {
    TransactionType.income => tx.amount,
    TransactionType.expense => -tx.amount,
    TransactionType.transfer => 0,
  };
}

String _formatDay(DateTime day) {
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
  return '${months[day.month - 1]} ${day.day}, ${day.year}';
}
