import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

class TransfersQuery {
  const TransfersQuery({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) {
    return other is TransfersQuery && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

final transfersProvider = NotifierProvider.autoDispose
    .family<
      TransfersNotifier,
      AsyncValue<List<Transfer>>,
      TransfersQuery
    >(TransfersNotifier.new);

class TransfersNotifier
    extends
        AutoDisposeFamilyNotifier<AsyncValue<List<Transfer>>, TransfersQuery> {
  StreamSubscription<List<Transfer>>? _subscription;

  @override
  AsyncValue<List<Transfer>> build(TransfersQuery arg) {
    final repo = ref.watch(transfersRepositoryProvider);
    _subscription = repo
        .watchTransfers(start: arg.start, end: arg.end)
        .listen(
          (transfers) => state = AsyncData(transfers),
          onError: (Object error, StackTrace stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}
