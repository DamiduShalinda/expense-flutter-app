import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/providers/loans_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/ui/screens/loan_payment_sheet.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';

class LoanDetailsScreen extends ConsumerWidget {
  const LoanDetailsScreen({super.key, required this.loanId});

  final int loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(loanDetailsProvider(loanId));
    final currencyCode = ref.watch(currencyCodeProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Loan details')),
      body: detailsAsync.when(
        data: (details) {
          final loan = details.loan;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        loan.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Outstanding',
                        amount: -loan.outstandingAmount,
                        currencyCode: currencyCode,
                      ),
                      const SizedBox(height: 4),
                      _SummaryRow(
                        label: 'Monthly installment',
                        amount: -loan.monthlyInstallment,
                        currencyCode: currencyCode,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${loan.durationMonths} months • '
                        '${loan.interestRate.toStringAsFixed(2)}% '
                        '${loan.interestType.name}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (!loan.isClosed) ...[
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => showLoanPaymentSheet(
                            context: context,
                            loan: loan,
                            installments: details.installments,
                            payments: details.payments,
                          ),
                          child: const Text('Pay installment'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Installments',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final item in details.installments)
                Card(
                  child: ListTile(
                    title: Text(
                      'Installment #${item.installmentNumber} '
                      '• ${_formatDate(item.dueDate)}',
                    ),
                    subtitle: Text(item.isPaid ? 'Paid' : 'Unpaid'),
                    trailing: AmountText(
                      -item.totalDue,
                      currencyCode: currencyCode,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Payments',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (details.payments.isEmpty)
                const Text('No payments yet')
              else
                for (final payment in details.payments)
                  Card(
                    child: ListTile(
                      title: Text(_formatDate(payment.date)),
                      subtitle: Text(
                        'Principal ${payment.principalPart} • '
                        'Interest ${payment.interestPart}',
                      ),
                      trailing: AmountText(
                        -payment.amount,
                        currencyCode: currencyCode,
                      ),
                    ),
                  ),
            ],
          );
        },
        error: (error, _) => Center(child: Text('Failed to load: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.currencyCode,
  });

  final String label;
  final int amount;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        AmountText(amount, currencyCode: currencyCode),
      ],
    );
  }
}
