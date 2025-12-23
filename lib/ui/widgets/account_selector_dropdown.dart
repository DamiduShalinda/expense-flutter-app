import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';

class AccountSelectorDropdown extends ConsumerWidget {
  const AccountSelectorDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText = 'Account',
    this.enabled = true,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final String labelText;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(activeAccountsProvider);
    return accountsAsync.when(
      data: (accounts) {
        return DropdownButtonFormField<int>(
          value: _validValue(value, accounts),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(labelText: labelText),
          items: accounts
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
              .toList(),
        );
      },
      error: (error, _) {
        return InputDecorator(
          decoration: InputDecoration(labelText: labelText),
          child: Text('Failed to load accounts: $error'),
        );
      },
      loading: () {
        return InputDecorator(
          decoration: InputDecoration(labelText: labelText),
          child: const LinearProgressIndicator(),
        );
      },
    );
  }

  int? _validValue(int? current, List<Account> accounts) {
    if (current == null) return null;
    return accounts.any((a) => a.id == current) ? current : null;
  }
}
