import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final activeAccountsProvider =
    NotifierProvider.autoDispose<
      ActiveAccountsNotifier,
      AsyncValue<List<Account>>
    >(ActiveAccountsNotifier.new);

class ActiveAccountsNotifier
    extends AutoDisposeNotifier<AsyncValue<List<Account>>> {
  StreamSubscription<List<Account>>? _subscription;

  @override
  AsyncValue<List<Account>> build() {
    final repo = ref.watch(accountsRepositoryProvider);
    _subscription = repo.watchActiveAccounts().listen(
      (accounts) => state = AsyncData(accounts),
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}

final totalBalanceProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  final accountsAsync = ref.watch(activeAccountsProvider);
  return accountsAsync.whenData(
    (accounts) => accounts.fold<int>(0, (sum, a) => sum + a.currentBalance),
  );
});
