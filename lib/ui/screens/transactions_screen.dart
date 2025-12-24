import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/providers/transfers_provider.dart';
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
  _FilterType? _activeFilter;
  int? _selectedAccountId;
  int? _selectedCategoryId;
  _DateFilter _dateFilter = _DateFilter.thisMonth;
  _SortType _sortType = _SortType.date;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final range = _rangeFor(_dateFilter);
    _rangeStart = range.start;
    _rangeEnd = range.end;
  }

  @override
  Widget build(BuildContext context) {
    final query = TransactionsQuery(
      start: _rangeStart,
      end: _rangeEnd,
      accountId: _selectedAccountId,
      categoryId: _selectedCategoryId,
    );
    final transactionsAsync = ref.watch(transactionsProvider(query));
    final transfersAsync = ref.watch(
      transfersProvider(TransfersQuery(start: _rangeStart, end: _rangeEnd)),
    );
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

    final transfersByTxId = transfersAsync.maybeWhen(
      data: (transfers) {
        final map = <int, Transfer>{};
        for (final t in transfers) {
          for (final id in _linkedIds(t)) {
            map[id] = t;
          }
        }
        return map;
      },
      orElse: () => const <int, Transfer>{},
    );

    return Scaffold(
      body: Column(
        children: [
          _buildFilterSection(context, accountsAsync, categoriesAsync),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: transactionsAsync.when(
                data: (items) {
                  final filteredItems = items.where((tx) {
                    if (_searchQuery.trim().isEmpty) return true;
                    return _matchesSearch(
                      tx: tx,
                      query: _searchQuery,
                      accountsById: accountsById,
                      categoriesById: categoriesById,
                      transfersByTxId: transfersByTxId,
                    );
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const KeyedSubtree(
                      key: ValueKey('tx-empty'),
                      child: Center(child: Text('No transactions yet')),
                    );
                  }

                  if (_sortType == _SortType.amount) {
                    filteredItems.sort((a, b) {
                      final amountCompare = b.amount.compareTo(a.amount);
                      if (amountCompare != 0) return amountCompare;
                      return b.date.compareTo(a.date);
                    });
                    return KeyedSubtree(
                      key: const ValueKey('tx-data'),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final tx = filteredItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(_titleFor(tx, categoriesById)),
                              subtitle: Text(
                                _subtitleFor(
                                  tx,
                                  accountsById,
                                  transfersByTxId,
                                ),
                              ),
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
                          );
                        },
                      ),
                    );
                  }

                  final groups = _groupByDay(filteredItems);
                  final days = groups.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

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
                                  subtitle: Text(
                                    _subtitleFor(
                                      tx,
                                      accountsById,
                                      transfersByTxId,
                                    ),
                                  ),
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
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTransferFab(context),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add-transaction',
            onPressed: () => showAddTransactionSheet(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    AsyncValue<List<Account>> accountsAsync,
    AsyncValue<Map<int?, List<Category>>> categoriesAsync,
  ) {
    final accounts = accountsAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <Account>[],
    );
    final categories = categoriesAsync.maybeWhen(
      data: (grouped) {
        final result = <Category>[];
        for (final entry in grouped.entries) {
          result.addAll(entry.value);
        }
        result.sort((a, b) => a.name.compareTo(b.name));
        return result;
      },
      orElse: () => const <Category>[],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search transactions',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Sort: Date'),
                selected: _sortType == _SortType.date,
                onSelected: (_) => setState(() => _sortType = _SortType.date),
              ),
              ChoiceChip(
                label: const Text('Sort: Amount'),
                selected: _sortType == _SortType.amount,
                onSelected: (_) => setState(() => _sortType = _SortType.amount),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Account'),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                selected: _activeFilter == _FilterType.account,
                onSelected: (_) => _toggleFilter(_FilterType.account),
              ),
              ChoiceChip(
                label: const Text('Category'),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                selected: _activeFilter == _FilterType.category,
                onSelected: (_) => _toggleFilter(_FilterType.category),
              ),
              ChoiceChip(
                label: const Text('Date'),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                selected: _activeFilter == _FilterType.date,
                onSelected: (_) => _toggleFilter(_FilterType.date),
              ),
            ],
          ),
          if (_activeFilter != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildFilterOptions(
                context: context,
                accounts: accounts,
                categories: categories,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildFilterOptions({
    required BuildContext context,
    required List<Account> accounts,
    required List<Category> categories,
  }) {
    switch (_activeFilter) {
      case _FilterType.account:
        return [
          ChoiceChip(
            label: const Text('All'),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selected: _selectedAccountId == null,
            onSelected: (_) => setState(() => _selectedAccountId = null),
          ),
          for (final account in accounts)
            ChoiceChip(
              label: Text(account.name),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              selected: _selectedAccountId == account.id,
              onSelected: (_) => setState(() {
                _selectedAccountId = account.id;
              }),
            ),
        ];
      case _FilterType.category:
        return [
          ChoiceChip(
            label: const Text('All'),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selected: _selectedCategoryId == null,
            onSelected: (_) => setState(() => _selectedCategoryId = null),
          ),
          for (final category in categories)
            ChoiceChip(
              label: Text(category.name),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              selected: _selectedCategoryId == category.id,
              onSelected: (_) => setState(() {
                _selectedCategoryId = category.id;
              }),
            ),
        ];
      case _FilterType.date:
        return [
          ChoiceChip(
            label: const Text('This month'),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selected: _dateFilter == _DateFilter.thisMonth,
            onSelected: (_) => _setDateFilter(_DateFilter.thisMonth),
          ),
          ChoiceChip(
            label: const Text('Last month'),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selected: _dateFilter == _DateFilter.lastMonth,
            onSelected: (_) => _setDateFilter(_DateFilter.lastMonth),
          ),
          ChoiceChip(
            label: const Text('All'),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selected: _dateFilter == _DateFilter.all,
            onSelected: (_) => _setDateFilter(_DateFilter.all),
          ),
        ];
      case null:
        return const [];
    }
  }

  FloatingActionButton _buildTransferFab(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'add-transfer',
      onPressed: () => showAddTransferSheet(context),
      child: const Icon(Icons.swap_horiz_outlined),
    );
  }

  void _toggleFilter(_FilterType type) {
    setState(() {
      _activeFilter = _activeFilter == type ? null : type;
    });
  }

  void _setDateFilter(_DateFilter filter) {
    final range = _rangeFor(filter);
    setState(() {
      _dateFilter = filter;
      _rangeStart = range.start;
      _rangeEnd = range.end;
    });
  }
}

_DateRange _rangeFor(_DateFilter filter) {
  final now = DateTime.now();
  return switch (filter) {
    _DateFilter.thisMonth => _DateRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999),
    ),
    _DateFilter.lastMonth => _DateRange(
      start: DateTime(now.year, now.month - 1, 1),
      end: DateTime(now.year, now.month, 0, 23, 59, 59, 999),
    ),
    _DateFilter.all => _DateRange(
      start: DateTime(1970, 1, 1),
      end: DateTime(9999, 12, 31, 23, 59, 59, 999),
    ),
  };
}

class _DateRange {
  const _DateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

enum _FilterType { account, category, date }

enum _DateFilter { thisMonth, lastMonth, all }

enum _SortType { date, amount }

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

String _subtitleFor(
  Transaction tx,
  Map<int, Account> accountsById,
  Map<int, Transfer> transfersByTxId,
) {
  final account = accountsById[tx.accountId];
  final accountLabel = account == null
      ? 'Account #${tx.accountId}'
      : account.name;
  if (tx.type == TransactionType.transfer) {
    final transfer = transfersByTxId[tx.id];
    if (transfer == null) return 'Transfer';
    final fromAccount = accountsById[transfer.fromAccountId];
    final toAccount = accountsById[transfer.toAccountId];
    final fromLabel =
        fromAccount == null
            ? 'Account #${transfer.fromAccountId}'
            : fromAccount.name;
    final toLabel =
        toAccount == null
            ? 'Account #${transfer.toAccountId}'
            : toAccount.name;
    return '$fromLabel → $toLabel';
  }
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

bool _matchesSearch({
  required Transaction tx,
  required String query,
  required Map<int, Account> accountsById,
  required Map<int, Category> categoriesById,
  required Map<int, Transfer> transfersByTxId,
}) {
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return true;

  final amountText = tx.amount.toString();
  final categoryName = tx.categoryId == null
      ? 'uncategorized'
      : (categoriesById[tx.categoryId]?.name ?? 'uncategorized');
  final accountName = accountsById[tx.accountId]?.name ?? '';
  final note = tx.note ?? '';
  final title = _titleFor(tx, categoriesById);
  final subtitle = _subtitleFor(tx, accountsById, transfersByTxId);

  final haystack =
      '$title $subtitle $categoryName $accountName $note $amountText';
  return haystack.toLowerCase().contains(normalized);
}

List<int> _linkedIds(Transfer transfer) {
  try {
    final decoded = jsonDecode(transfer.linkedTransactionIds);
    if (decoded is! List) return const [];
    return decoded.whereType<int>().toList();
  } catch (_) {
    return const [];
  }
}
