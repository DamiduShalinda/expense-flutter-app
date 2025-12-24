import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/providers/loans_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/ui/screens/loan_details_screen.dart';
import 'package:expense_manage/ui/screens/loan_form_screen.dart';
import 'package:expense_manage/ui/widgets/amount_text.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeLoansProvider);
    final closedAsync = ref.watch(closedLoansProvider);
    final currencyCode = ref.watch(currencyCodeProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const LoanFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Active', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          activeAsync.when(
            data: (loans) {
              if (loans.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('No active loans'),
                );
              }
              return Column(
                children: [
                  for (final loan in loans)
                    Card(
                      child: ListTile(
                        title: Text(loan.name),
                        subtitle: Text(
                          'Outstanding ${loan.outstandingAmount} • '
                          '${loan.durationMonths} months',
                        ),
                        trailing: AmountText(
                          -loan.outstandingAmount,
                          currencyCode: currencyCode,
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                LoanDetailsScreen(loanId: loan.id),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            error: (error, _) =>
                Text('Failed to load active loans: $error'),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text('Closed', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          closedAsync.when(
            data: (loans) {
              if (loans.isEmpty) {
                return const Text('No closed loans');
              }
              return Column(
                children: [
                  for (final loan in loans)
                    Card(
                      child: ListTile(
                        title: Text(loan.name),
                        subtitle: const Text('Closed'),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                LoanDetailsScreen(loanId: loan.id),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            error: (error, _) =>
                Text('Failed to load closed loans: $error'),
            loading: () => const LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
