import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';
import 'package:expense_manage/ui/widgets/account_selector_dropdown.dart';
import 'package:expense_manage/ui/widgets/category_selector_bottom_sheet.dart';

Future<void> showAddTransactionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const AddTransactionSheet(),
  );
}

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  int? _accountId;
  Category? _category;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(categoriesRepositoryProvider).ensureDefaultCategories();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

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
              DropdownButtonFormField<TransactionType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text('Expense'),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text('Income'),
                  ),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _type = value;
                          _category = null;
                        });
                      },
              ),
              const SizedBox(height: 12),
              AccountSelectorDropdown(
                value: _accountId,
                enabled: !_saving,
                onChanged: (value) => setState(() => _accountId = value),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Category'),
                subtitle: Text(_category?.name ?? 'Optional'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _saving
                    ? null
                    : () async {
                        final selected = await showCategorySelectorBottomSheet(
                          context,
                          selectedCategoryId: _category?.id,
                          isIncome: _type == TransactionType.income
                              ? true
                              : false,
                        );
                        if (selected == null) return;
                        setState(() => _category = selected);
                      },
              ),
              const SizedBox(height: 8),
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
              TextFormField(
                controller: _noteController,
                enabled: !_saving,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
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

  Future<void> _save(BuildContext context) async {
    if (_accountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select an account')));
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = int.parse(_amountController.text.trim());
    final accountId = _accountId!;

    setState(() => _saving = true);
    try {
      if (_type == TransactionType.expense) {
        final account = await ref
            .read(accountsRepositoryProvider)
            .requireAccount(accountId);
        if (account.type != AccountType.creditCard &&
            amount > account.currentBalance) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
          return;
        }
      }

      await ref
          .read(transactionsRepositoryProvider)
          .addTransaction(
            accountId: accountId,
            amount: amount,
            type: _type,
            categoryId: _category?.id,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            date: DateTime(_date.year, _date.month, _date.day),
            isPending: false,
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
