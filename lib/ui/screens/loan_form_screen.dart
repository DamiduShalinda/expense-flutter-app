import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/loan_service_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';
import 'package:expense_manage/ui/widgets/account_selector_dropdown.dart';

class LoanFormScreen extends ConsumerStatefulWidget {
  const LoanFormScreen({super.key});

  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController(text: '0');
  final _durationController = TextEditingController(text: '12');
  final _paymentDayController = TextEditingController(text: '1');

  int? _accountId;
  LoanInterestType _interestType = LoanInterestType.fixed;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(accountsRepositoryProvider).ensureDefaultAccounts();
      await ref.read(categoriesRepositoryProvider).ensureDefaultCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _interestRateController.dispose();
    _durationController.dispose();
    _paymentDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Loan')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Loan name'),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Enter a loan name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AccountSelectorDropdown(
                  value: _accountId,
                  enabled: !_saving,
                  onChanged: (value) => setState(() => _accountId = value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _interestRateController,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Interest rate (%)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid interest rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<LoanInterestType>(
                  value: _interestType,
                  decoration: const InputDecoration(labelText: 'Interest type'),
                  items: const [
                    DropdownMenuItem(
                      value: LoanInterestType.fixed,
                      child: Text('Fixed'),
                    ),
                    DropdownMenuItem(
                      value: LoanInterestType.compound,
                      child: Text('Compound'),
                    ),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) {
                          if (value == null) return;
                          setState(() => _interestType = value);
                        },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _durationController,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Duration (months)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _paymentDayController,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Payment day'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 1 || parsed > 28) {
                      return 'Enter a day between 1 and 28';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : () => _save(context),
                    child: Text(_saving ? 'Saving…' : 'Create loan'),
                  ),
                ),
              ],
            ),
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
    final interestRate = double.parse(_interestRateController.text.trim());
    final durationMonths = int.parse(_durationController.text.trim());
    final paymentDay = int.parse(_paymentDayController.text.trim());

    setState(() => _saving = true);
    try {
      await ref.read(loanServiceProvider).createLoan(
        name: _nameController.text.trim(),
        accountId: _accountId!,
        principalAmount: amount,
        interestRate: interestRate,
        interestType: _interestType,
        durationMonths: durationMonths,
        paymentDay: paymentDay,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loan created')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create loan: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
