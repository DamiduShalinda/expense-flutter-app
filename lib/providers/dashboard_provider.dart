import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/domain/services/dashboard_calculator.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

class WeeklyDashboardState {
  const WeeklyDashboardState({
    required this.start,
    required this.end,
    required this.summary,
    required this.topExpenseCategories,
    required this.dailyIncomeExpense,
  });

  final DateTime start;
  final DateTime end;
  final DashboardSummary summary;
  final List<CategoryBreakdownItem> topExpenseCategories;
  final List<({int income, int expense})> dailyIncomeExpense;
}

final weeklyDashboardProvider =
    NotifierProvider.autoDispose<
      WeeklyDashboardNotifier,
      AsyncValue<WeeklyDashboardState>
    >(WeeklyDashboardNotifier.new);

class WeeklyDashboardNotifier
    extends AutoDisposeNotifier<AsyncValue<WeeklyDashboardState>> {
  StreamSubscription<List<Transaction>>? _subscription;
  final _calculator = const DashboardCalculator();

  @override
  AsyncValue<WeeklyDashboardState> build() {
    final now = DateTime.now();
    final weekday = ref.watch(firstDayOfWeekProvider).value ?? DateTime.monday;
    final start = startOfWeek(now, firstDayOfWeek: weekday);
    final end = start.add(const Duration(days: 7));

    final repo = ref.watch(transactionsRepositoryProvider);
    _subscription = repo
        .watchTransactions(start: start, end: end)
        .listen(
          (transactions) {
            final summary = _calculator.weeklySummary(transactions);
            final breakdown = _calculator.topExpenseCategories(
              transactions,
              topN: 5,
            );
            final daily = _calculator.dailyIncomeExpense(
              start: start,
              days: 7,
              transactions: transactions,
            );
            state = AsyncData(
              WeeklyDashboardState(
                start: start,
                end: end,
                summary: summary,
                topExpenseCategories: breakdown,
                dailyIncomeExpense: daily,
              ),
            );
          },
          onError: (Object error, StackTrace stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );

    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}

DateTime startOfWeek(DateTime date, {required int firstDayOfWeek}) {
  final local = DateTime(date.year, date.month, date.day);
  final offset = (local.weekday - firstDayOfWeek) % DateTime.daysPerWeek;
  return local.subtract(Duration(days: offset));
}
