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

  test('dailyIncomeExpense buckets by day', () {
    final start = DateTime(2025, 1, 1);
    final series = calculator.dailyIncomeExpense(
      start: start,
      days: 3,
      transactions: [
        Transaction(
          id: 1,
          amount: 10,
          type: TransactionType.income,
          accountId: 1,
          categoryId: null,
          note: null,
          date: DateTime(2025, 1, 1, 10),
          isPending: false,
        ),
        Transaction(
          id: 2,
          amount: 5,
          type: TransactionType.expense,
          accountId: 1,
          categoryId: null,
          note: null,
          date: DateTime(2025, 1, 2, 10),
          isPending: false,
        ),
        Transaction(
          id: 3,
          amount: 999,
          type: TransactionType.transfer,
          accountId: 1,
          categoryId: null,
          note: null,
          date: DateTime(2025, 1, 3, 10),
          isPending: false,
        ),
        Transaction(
          id: 4,
          amount: 100,
          type: TransactionType.expense,
          accountId: 1,
          categoryId: null,
          note: null,
          date: DateTime(2025, 1, 2, 10),
          isPending: true,
        ),
      ],
    );

    expect(series.length, 3);
    expect(series[0].income, 10);
    expect(series[0].expense, 0);
    expect(series[1].income, 0);
    expect(series[1].expense, 5);
    expect(series[2].income, 0);
    expect(series[2].expense, 0);
  });
}
