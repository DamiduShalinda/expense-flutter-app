import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';
import 'package:expense_manage/providers/transactions_provider.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';

class AccountTransactionsScreen extends ConsumerWidget {
  const AccountTransactionsScreen({super.key, required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(_accountProvider(accountId));
    final categoriesAsync = ref.watch(categoriesByParentProvider);

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

    final query = TransactionsQuery(
      start: DateTime(2000, 1, 1),
      end: DateTime(2100, 12, 31),
      accountId: accountId,
    );
    final transactionsAsync = ref.watch(transactionsProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: accountAsync.when(
          data: (a) => Text(a.name),
          loading: () => const Text('Account'),
          error: (_, __) => const Text('Account'),
        ),
      ),
      body: accountAsync.when(
        data: (account) {
          return transactionsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Center(
                  child: Text('No transactions for this account'),
                );
              }

              final groups = _groupByDay(items);
              final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));

              return ListView.builder(
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
                            subtitle: Text(
                              tx.note?.trim().isEmpty ?? true
                                  ? _typeLabel(tx.type)
                                  : '${_typeLabel(tx.type)} • ${tx.note}',
                            ),
                            trailing: AmountText(
                              _displayAmount(tx, account),
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
              );
            },
            error: (error, _) => Center(child: Text('Failed to load: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (error, _) => Center(child: Text('Failed to load: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _accountProvider = FutureProvider.autoDispose.family<Account, int>((
  ref,
  accountId,
) async {
  final repo = ref.watch(accountsRepositoryProvider);
  return repo.requireAccount(accountId);
});

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

String _typeLabel(TransactionType type) {
  return switch (type) {
    TransactionType.income => 'Income',
    TransactionType.expense => 'Expense',
    TransactionType.transfer => 'Transfer',
  };
}

int _displayAmount(Transaction tx, Account account) {
  return switch (tx.type) {
    TransactionType.income =>
      account.type == AccountType.creditCard ? -tx.amount : tx.amount,
    TransactionType.expense =>
      account.type == AccountType.creditCard ? tx.amount : -tx.amount,
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
