import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final categoriesByParentProvider =
    NotifierProvider.autoDispose<
      CategoriesByParentNotifier,
      AsyncValue<Map<int?, List<Category>>>
    >(CategoriesByParentNotifier.new);

class CategoriesByParentNotifier
    extends AutoDisposeNotifier<AsyncValue<Map<int?, List<Category>>>> {
  StreamSubscription<List<Category>>? _subscription;

  @override
  AsyncValue<Map<int?, List<Category>>> build() {
    final repo = ref.watch(categoriesRepositoryProvider);
    _subscription = repo.watchAllCategories().listen(
      (categories) {
        final byParent = <int?, List<Category>>{};
        for (final category in categories) {
          byParent.putIfAbsent(category.parentId, () => []).add(category);
        }
        state = AsyncData(byParent);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}
