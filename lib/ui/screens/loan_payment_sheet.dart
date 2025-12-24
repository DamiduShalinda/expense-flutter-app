import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

Future<void> showLoanPaymentSheet({
  required BuildContext context,
  required Loan loan,
  required List<LoanInstallment> installments,
  required List<LoanPayment> payments,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _LoanPaymentSheet(
      loan: loan,
      installments: installments,
      payments: payments,
    ),
  );
}

class _InstallmentOption {
  const _InstallmentOption({
    required this.installment,
    required this.remaining,
  });

  final LoanInstallment installment;
  final int remaining;
}

class _LoanPaymentSheet extends ConsumerStatefulWidget {
  const _LoanPaymentSheet({
    required this.loan,
    required this.installments,
    required this.payments,
  });

  final Loan loan;
  final List<LoanInstallment> installments;
  final List<LoanPayment> payments;

  @override
  ConsumerState<_LoanPaymentSheet> createState() => _LoanPaymentSheetState();
}

class _LoanPaymentSheetState extends ConsumerState<_LoanPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  _InstallmentOption? _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final options = _availableInstallments();
    if (options.isNotEmpty) {
      _selected = options.first;
      _amountController.text = options.first.remaining.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final options = _availableInstallments();

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
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
              if (options.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('All installments are paid'),
                )
              else ...[
                DropdownButtonFormField<_InstallmentOption>(
                  value: _selected,
                  decoration: const InputDecoration(
                    labelText: 'Installment',
                  ),
                  items: options
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(
                            '#${option.installment.installmentNumber} '
                            'due ${_formatDate(option.installment.dueDate)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          if (value == null) return;
                          setState(() {
                            _selected = value;
                            _amountController.text =
                                value.remaining.toString();
                          });
                        },
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
                    final remaining = _selected?.remaining ?? 0;
                    if (parsed > remaining) {
                      return 'Amount exceeds remaining due';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : () => _submit(context),
                    child: Text(_saving ? 'Saving…' : 'Record payment'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<_InstallmentOption> _availableInstallments() {
    final options = <_InstallmentOption>[];
    for (final installment in widget.installments) {
      final paid = widget.payments
          .where((p) => p.installmentId == installment.id)
          .fold<int>(0, (sum, p) => sum + p.amount);
      final remaining = max(0, installment.totalDue - paid);
      if (remaining > 0) {
        options.add(
          _InstallmentOption(
            installment: installment,
            remaining: remaining,
          ),
        );
      }
    }
    return options;
  }

  Future<void> _submit(BuildContext context) async {
    final selected = _selected;
    if (selected == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = int.parse(_amountController.text.trim());
    setState(() => _saving = true);
    try {
      await ref.read(loanPaymentRepositoryProvider).recordPayment(
        loanId: widget.loan.id,
        installmentId: selected.installment.id,
        accountId: widget.loan.accountId,
        amount: amount,
        date: DateTime.now(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment recorded')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to record payment: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
