import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

class TransactionsQuery {
  const TransactionsQuery({
    required this.start,
    required this.end,
    this.accountId,
    this.categoryId,
  });

  final DateTime start;
  final DateTime end;
  final int? accountId;
  final int? categoryId;

  @override
  bool operator ==(Object other) {
    return other is TransactionsQuery &&
        other.start == start &&
        other.end == end &&
        other.accountId == accountId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode => Object.hash(start, end, accountId, categoryId);
}

final transactionsProvider = NotifierProvider.autoDispose
    .family<
      TransactionsNotifier,
      AsyncValue<List<Transaction>>,
      TransactionsQuery
    >(TransactionsNotifier.new);

class TransactionsNotifier
    extends
        AutoDisposeFamilyNotifier<
          AsyncValue<List<Transaction>>,
          TransactionsQuery
        > {
  StreamSubscription<List<Transaction>>? _subscription;

  @override
  AsyncValue<List<Transaction>> build(TransactionsQuery arg) {
    final repo = ref.watch(transactionsRepositoryProvider);
    _subscription = repo
        .watchTransactions(
          start: arg.start,
          end: arg.end,
          accountId: arg.accountId,
          categoryId: arg.categoryId,
        )
        .listen(
          (transactions) => state = AsyncData(transactions),
          onError: (Object error, StackTrace stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}
