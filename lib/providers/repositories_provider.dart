import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/loan_payment_repository.dart';
import 'package:expense_manage/data/repositories/loan_repository.dart';
import 'package:expense_manage/data/repositories/preferences_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';
import 'package:expense_manage/providers/database_provider.dart';

final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  return AccountsRepository(ref.watch(appDatabaseProvider));
});

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository(ref.watch(appDatabaseProvider));
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(ref.watch(appDatabaseProvider));
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepository(
    ref.watch(appDatabaseProvider),
    accountsRepository: ref.watch(accountsRepositoryProvider),
  );
});

final transfersRepositoryProvider = Provider<TransfersRepository>((ref) {
  return TransfersRepository(
    ref.watch(appDatabaseProvider),
    accountsRepository: ref.watch(accountsRepositoryProvider),
  );
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepository(ref.watch(appDatabaseProvider));
});

final loanPaymentRepositoryProvider = Provider<LoanPaymentRepository>((ref) {
  return LoanPaymentRepository(
    ref.watch(appDatabaseProvider),
    transactionsRepository: ref.watch(transactionsRepositoryProvider),
    categoriesRepository: ref.watch(categoriesRepositoryProvider),
  );
});
