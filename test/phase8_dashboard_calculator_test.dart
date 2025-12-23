import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/domain/services/dashboard_calculator.dart';

void main() {
  const calculator = DashboardCalculator();

  Transaction tx({
    required int id,
    required int amount,
    required TransactionType type,
    int? categoryId,
    bool isPending = false,
  }) {
    return Transaction(
      id: id,
      amount: amount,
      type: type,
      accountId: 1,
      categoryId: categoryId,
      note: null,
      date: DateTime(2025, 1, 1),
      isPending: isPending,
    );
  }

  test('weeklySummary excludes pending and transfers', () {
    final summary = calculator.weeklySummary([
      tx(id: 1, amount: 100, type: TransactionType.income),
      tx(id: 2, amount: 50, type: TransactionType.expense),
      tx(id: 3, amount: 999, type: TransactionType.transfer),
      tx(id: 4, amount: 1000, type: TransactionType.expense, isPending: true),
    ]);

    expect(summary.incomeTotal, 100);
    expect(summary.expenseTotal, 50);
    expect(summary.net, 50);
  });

  test('topExpenseCategories groups by category and returns percentages', () {
    final items = calculator.topExpenseCategories([
      tx(id: 1, amount: 50, type: TransactionType.expense, categoryId: 10),
      tx(id: 2, amount: 25, type: TransactionType.expense, categoryId: 10),
      tx(id: 3, amount: 25, type: TransactionType.expense, categoryId: 11),
      tx(id: 4, amount: 100, type: TransactionType.income, categoryId: 12),
      tx(id: 5, amount: 999, type: TransactionType.expense, isPending: true),
    ], topN: 5);

    expect(items.length, 2);
    expect(items.first.categoryId, 10);
    expect(items.first.totalExpense, 75);
    expect(items.last.categoryId, 11);
    expect(items.last.totalExpense, 25);

    expect(items.first.percentage, closeTo(0.75, 0.0001));
    expect(items.last.percentage, closeTo(0.25, 0.0001));
  });
}
