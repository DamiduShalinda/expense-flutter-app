import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/domain/services/dashboard_calculator.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

class DashboardState {
  const DashboardState({
    required this.start,
    required this.end,
    required this.summary,
    required this.topExpenseCategories,
    required this.dailyIncomeExpense,
    required this.topExpenseNotes,
  });

  final DateTime start;
  final DateTime end;
  final DashboardSummary summary;
  final List<CategoryBreakdownItem> topExpenseCategories;
  final List<({int income, int expense})> dailyIncomeExpense;
  final List<NoteBreakdownItem> topExpenseNotes;
}

class DashboardQuery {
  const DashboardQuery({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) {
    return other is DashboardQuery && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

final dashboardProvider = NotifierProvider.autoDispose.family<
  DashboardNotifier,
  AsyncValue<DashboardState>,
  DashboardQuery
>(DashboardNotifier.new);

class DashboardNotifier
    extends AutoDisposeFamilyNotifier<AsyncValue<DashboardState>, DashboardQuery> {
  StreamSubscription<List<Transaction>>? _subscription;
  final _calculator = const DashboardCalculator();

  @override
  AsyncValue<DashboardState> build(DashboardQuery arg) {
    final repo = ref.watch(transactionsRepositoryProvider);
    _subscription = repo
        .watchTransactions(start: arg.start, end: arg.end)
        .listen(
          (transactions) {
            final summary = _calculator.summary(transactions);
            final breakdown = _calculator.topExpenseCategories(
              transactions,
              topN: 5,
            );
            final notes = _calculator.topExpenseNotes(transactions, topN: 5);
            final days = arg.end
                .difference(
                  DateTime(arg.start.year, arg.start.month, arg.start.day),
                )
                .inDays;
            final daily = _calculator.dailyIncomeExpense(
              start: arg.start,
              days: days,
              transactions: transactions,
            );
            state = AsyncData(
              DashboardState(
                start: arg.start,
                end: arg.end,
                summary: summary,
                topExpenseCategories: breakdown,
                dailyIncomeExpense: daily,
                topExpenseNotes: notes,
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
