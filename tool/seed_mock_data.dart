import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/preferences_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';
import 'package:expense_manage/domain/services/demo_mode_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final accountsRepo = AccountsRepository(db);
  final categoriesRepo = CategoriesRepository(db);
  final preferencesRepo = PreferencesRepository(db);
  final transactionsRepo = TransactionsRepository(
    db,
    accountsRepository: accountsRepo,
  );
  final transfersRepo = TransfersRepository(
    db,
    accountsRepository: accountsRepo,
  );

  try {
    final service = DemoModeService(
      db: db,
      accountsRepository: accountsRepo,
      categoriesRepository: categoriesRepo,
      transactionsRepository: transactionsRepo,
      transfersRepository: transfersRepo,
      preferencesRepository: preferencesRepo,
    );
    await service.enterDemoMode();
    stdout.writeln('Demo data inserted successfully.');
  } catch (e) {
    stderr.writeln('Failed to insert mock data: $e');
    exitCode = 1;
  } finally {
    await db.close();
  }
}
