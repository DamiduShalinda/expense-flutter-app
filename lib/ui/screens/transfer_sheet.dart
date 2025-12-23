import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

Future<void> showAddTransferSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const AddTransferSheet(),
  );
}

class AddTransferSheet extends ConsumerStatefulWidget {
  const AddTransferSheet({super.key});

  @override
  ConsumerState<AddTransferSheet> createState() => _AddTransferSheetState();
}

class _AddTransferSheetState extends ConsumerState<AddTransferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  int? _fromAccountId;
  int? _toAccountId;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final accountsAsync = ref.watch(activeAccountsProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              accountsAsync.when(
                data: (accounts) {
                  return Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: _validAccount(_fromAccountId, accounts),
                        decoration: const InputDecoration(labelText: 'From'),
                        items: accounts
                            .map(
                              (a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.name),
                              ),
                            )
                            .toList(),
                        onChanged: _saving
                            ? null
                            : (value) => setState(() => _fromAccountId = value),
                        validator: (value) =>
                            value == null ? 'Select an account' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _validAccount(_toAccountId, accounts),
                        decoration: const InputDecoration(labelText: 'To'),
                        items: accounts
                            .map(
                              (a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.name),
                              ),
                            )
                            .toList(),
                        onChanged: _saving
                            ? null
                            : (value) => setState(() => _toAccountId = value),
                        validator: (value) =>
                            value == null ? 'Select an account' : null,
                      ),
                    ],
                  );
                },
                error: (error, _) => Text('Failed to load accounts: $error'),
                loading: () => const LinearProgressIndicator(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                enabled: !_saving,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse((value ?? '').trim());
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Amount must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(_formatDate(_date)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _saving
                    ? null
                    : () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2100, 12, 31),
                          initialDate: _date,
                        );
                        if (picked == null) return;
                        setState(() => _date = picked);
                      },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : () => _save(context),
                  child: Text(_saving ? 'Saving…' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? _validAccount(int? current, List<Account> accounts) {
    if (current == null) return null;
    return accounts.any((a) => a.id == current) ? current : null;
  }

  Future<void> _save(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final fromId = _fromAccountId!;
    final toId = _toAccountId!;
    if (fromId == toId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select different accounts')),
      );
      return;
    }

    final amount = int.parse(_amountController.text.trim());

    setState(() => _saving = true);
    try {
      final fromAccount = await ref
          .read(accountsRepositoryProvider)
          .requireAccount(fromId);
      if (fromAccount.type != AccountType.creditCard &&
          amount > fromAccount.currentBalance) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
        return;
      }

      await ref
          .read(transfersRepositoryProvider)
          .createTransfer(
            fromAccountId: fromId,
            toAccountId: toId,
            amount: amount,
            date: DateTime(_date.year, _date.month, _date.day),
          );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

String _formatDate(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  return '${date.year}-$mm-$dd';
}
