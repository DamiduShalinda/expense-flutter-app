import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

Future<void> showAccountFormBottomSheet(
  BuildContext context, {
  int? accountId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => AccountFormSheet(accountId: accountId),
  );
}

class AccountFormSheet extends ConsumerStatefulWidget {
  const AccountFormSheet({super.key, this.accountId});

  final int? accountId;

  @override
  ConsumerState<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends ConsumerState<AccountFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _openingBalanceController = TextEditingController(text: '0');
  final _creditLimitController = TextEditingController();
  final _billingStartDayController = TextEditingController();
  final _dueDayController = TextEditingController();

  AccountType _type = AccountType.cash;
  bool _isArchived = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadIfEditing();
  }

  Future<void> _loadIfEditing() async {
    final id = widget.accountId;
    if (id == null) return;

    setState(() => _loading = true);
    try {
      final repo = ref.read(accountsRepositoryProvider);
      final account = await repo.requireAccount(id);

      _nameController.text = account.name;
      _openingBalanceController.text = account.openingBalance.toString();
      _type = account.type;
      _isArchived = account.isArchived;

      if (account.creditLimit != null) {
        _creditLimitController.text = account.creditLimit.toString();
      }
      if (account.billingStartDay != null) {
        _billingStartDayController.text = account.billingStartDay.toString();
      }
      if (account.dueDay != null) {
        _dueDayController.text = account.dueDay.toString();
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _openingBalanceController.dispose();
    _creditLimitController.dispose();
    _billingStartDayController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.accountId != null;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 16,
        ),
        child: _loading
            ? const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit account' : 'Add account',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        if (isEditing)
                          PopupMenuButton<_AccountMenuAction>(
                            onSelected: (action) =>
                                _onMenuAction(context, action),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: _AccountMenuAction.toggleArchive,
                                  child: Text(
                                    _isArchived ? 'Unarchive' : 'Archive',
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: _AccountMenuAction.delete,
                                  child: Text('Delete'),
                                ),
                              ];
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AccountType>(
                      value: _type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: const [
                        DropdownMenuItem(
                          value: AccountType.cash,
                          child: Text('Cash'),
                        ),
                        DropdownMenuItem(
                          value: AccountType.bank,
                          child: Text('Bank'),
                        ),
                        DropdownMenuItem(
                          value: AccountType.creditCard,
                          child: Text('Credit Card'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _type = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _openingBalanceController,
                      decoration: const InputDecoration(
                        labelText: 'Opening balance',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final parsed = int.tryParse((value ?? '').trim());
                        if (parsed == null) return 'Enter a valid number';
                        if (parsed < 0) return 'Must be 0 or greater';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_type == AccountType.creditCard) ...[
                      TextFormField(
                        controller: _creditLimitController,
                        decoration: const InputDecoration(
                          labelText: 'Credit limit (optional)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return null;
                          final parsed = int.tryParse(v);
                          if (parsed == null) return 'Enter a valid number';
                          if (parsed < 0) return 'Must be 0 or greater';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _billingStartDayController,
                        decoration: const InputDecoration(
                          labelText: 'Billing start day (optional)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: _optionalDayValidator,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dueDayController,
                        decoration: const InputDecoration(
                          labelText: 'Due day (optional)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: _optionalDayValidator,
                      ),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : () => _onSave(context),
                        child: Text(isEditing ? 'Save' : 'Create'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String? _optionalDayValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return null;
    final parsed = int.tryParse(v);
    if (parsed == null) return 'Enter a valid day';
    if (parsed < 1 || parsed > 31) return 'Day must be 1–31';
    return null;
  }

  Future<void> _onSave(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final repo = ref.read(accountsRepositoryProvider);
    final name = _nameController.text.trim();
    final openingBalance = int.parse(_openingBalanceController.text.trim());

    final creditLimit = _creditLimitController.text.trim().isEmpty
        ? null
        : int.parse(_creditLimitController.text.trim());
    final billingStartDay = _billingStartDayController.text.trim().isEmpty
        ? null
        : int.parse(_billingStartDayController.text.trim());
    final dueDay = _dueDayController.text.trim().isEmpty
        ? null
        : int.parse(_dueDayController.text.trim());

    setState(() => _loading = true);
    try {
      final id = widget.accountId;
      if (id == null) {
        await repo.createAccount(
          name: name,
          type: _type,
          openingBalance: openingBalance,
          creditLimit: creditLimit,
          billingStartDay: billingStartDay,
          dueDay: dueDay,
        );
      } else {
        await repo.updateAccount(
          accountId: id,
          name: name,
          type: _type,
          openingBalance: openingBalance,
          creditLimit: creditLimit,
          billingStartDay: billingStartDay,
          dueDay: dueDay,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onMenuAction(
    BuildContext context,
    _AccountMenuAction action,
  ) async {
    final accountId = widget.accountId;
    if (accountId == null) return;

    final repo = ref.read(accountsRepositoryProvider);

    switch (action) {
      case _AccountMenuAction.toggleArchive:
        setState(() => _loading = true);
        try {
          final next = !_isArchived;
          await repo.setArchived(accountId: accountId, isArchived: next);
          if (mounted) setState(() => _isArchived = next);
        } finally {
          if (mounted) setState(() => _loading = false);
        }
        break;
      case _AccountMenuAction.delete:
        final hasTx = await repo.hasTransactions(accountId);
        if (hasTx) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot delete an account with transactions'),
            ),
          );
          return;
        }

        if (!context.mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete account?'),
            content: const Text('This cannot be undone.'),
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

        setState(() => _loading = true);
        try {
          await repo.deleteAccount(accountId);
          if (mounted) Navigator.pop(context);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        } finally {
          if (mounted) setState(() => _loading = false);
        }
        break;
    }
  }
}

enum _AccountMenuAction { toggleArchive, delete }
