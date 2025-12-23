import 'package:expense_manage/data/database/app_database.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.incomeTotal,
    required this.expenseTotal,
  });

  final int incomeTotal;
  final int expenseTotal;

  int get net => incomeTotal - expenseTotal;
}

class CategoryBreakdownItem {
  const CategoryBreakdownItem({
    required this.categoryId,
    required this.totalExpense,
    required this.percentage,
  });

  final int? categoryId;
  final int totalExpense;
  final double percentage;
}

class DashboardCalculator {
  const DashboardCalculator();

  DashboardSummary weeklySummary(Iterable<Transaction> transactions) {
    var income = 0;
    var expense = 0;

    for (final tx in transactions) {
      if (tx.isPending) continue;
      if (tx.type == TransactionType.transfer) continue;
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        expense += tx.amount;
      }
    }

    return DashboardSummary(incomeTotal: income, expenseTotal: expense);
  }

  List<CategoryBreakdownItem> topExpenseCategories(
    Iterable<Transaction> transactions, {
    int topN = 5,
  }) {
    final totals = <int?, int>{};
    var totalExpense = 0;

    for (final tx in transactions) {
      if (tx.isPending) continue;
      if (tx.type != TransactionType.expense) continue;
      totalExpense += tx.amount;
      totals[tx.categoryId] = (totals[tx.categoryId] ?? 0) + tx.amount;
    }

    if (totalExpense <= 0) return const [];

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(topN)
        .map(
          (e) => CategoryBreakdownItem(
            categoryId: e.key,
            totalExpense: e.value,
            percentage: e.value / totalExpense,
          ),
        )
        .toList();
  }
}
