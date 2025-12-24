import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/domain/services/demo_mode_service.dart';
import 'package:expense_manage/providers/database_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final demoModeServiceProvider = Provider<DemoModeService>((ref) {
  return DemoModeService(
    db: ref.watch(appDatabaseProvider),
    accountsRepository: ref.watch(accountsRepositoryProvider),
    categoriesRepository: ref.watch(categoriesRepositoryProvider),
    transactionsRepository: ref.watch(transactionsRepositoryProvider),
    transfersRepository: ref.watch(transfersRepositoryProvider),
    preferencesRepository: ref.watch(preferencesRepositoryProvider),
  );
});

