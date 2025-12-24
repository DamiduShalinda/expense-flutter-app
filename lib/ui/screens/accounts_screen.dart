import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';
import 'package:expense_manage/ui/screens/account_form_screen.dart';
import 'package:expense_manage/ui/screens/account_transactions_screen.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';
import 'package:expense_manage/ui/widgets/analytics_bar_chart.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(activeAccountsProvider);
    final totalAsync = ref.watch(totalBalanceProvider);
    final currencyCode = ref.watch(currencyCodeProvider).value;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: accountsAsync.when(
          data: (accounts) {
            return KeyedSubtree(
              key: const ValueKey('accounts-data'),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Expanded(child: Text('Total')),
                          totalAsync.when(
                            data: (total) =>
                                AmountText(total, currencyCode: currencyCode),
                            error: (error, _) => Text('$error'),
                            loading: () => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (accounts.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Account balances',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            AnalyticsBarChart(
                              values:
                                  accounts
                                      .map(
                                        (a) =>
                                            _displayBalance(a).toDouble(),
                                      )
                                      .toList(),
                              labels:
                                  accounts
                                      .map((a) => _shortLabel(a.name))
                                      .toList(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Current balance by account',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (accounts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: Text('No accounts yet')),
                    )
                  else
                    ...accounts.map(
                      (a) => Card(
                        child: ListTile(
                          leading: Icon(_iconForType(a.type)),
                          title: Text(a.name),
                          subtitle: Text(_labelForType(a.type)),
                          trailing: SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: AmountText(
                                    _displayBalance(a),
                                    currencyCode: currencyCode,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Edit',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => showAccountFormBottomSheet(
                                    context,
                                    accountId: a.id,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _confirmDelete(context, ref, a),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  AccountTransactionsScreen(accountId: a.id),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          error: (error, _) => KeyedSubtree(
            key: const ValueKey('accounts-error'),
            child: Center(child: Text('Failed to load: $error')),
          ),
          loading: () => const KeyedSubtree(
            key: ValueKey('accounts-loading'),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAccountFormBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Account account,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete account?'),
      content: Text('Delete "${account.name}"? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    await ref.read(accountsRepositoryProvider).deleteAccount(account.id);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
  }
}

int _displayBalance(Account a) {
  if (a.type == AccountType.creditCard) return -a.currentBalance;
  return a.currentBalance;
}

String _labelForType(AccountType type) {
  return switch (type) {
    AccountType.cash => 'Cash',
    AccountType.bank => 'Bank',
    AccountType.creditCard => 'Credit Card',
  };
}

IconData _iconForType(AccountType type) {
  return switch (type) {
    AccountType.cash => Icons.payments_outlined,
    AccountType.bank => Icons.account_balance_outlined,
    AccountType.creditCard => Icons.credit_card_outlined,
  };
}

String _shortLabel(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'N/A';
  if (trimmed.length <= 6) return trimmed;
  return trimmed.substring(0, 6);
}
