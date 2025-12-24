import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/preferences_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';

class DemoModeService {
  DemoModeService({
    required AppDatabase db,
    required AccountsRepository accountsRepository,
    required CategoriesRepository categoriesRepository,
    required TransactionsRepository transactionsRepository,
    required TransfersRepository transfersRepository,
    required PreferencesRepository preferencesRepository,
  }) : _db = db,
       _accounts = accountsRepository,
       _categories = categoriesRepository,
       _transactions = transactionsRepository,
       _transfers = transfersRepository,
       _preferences = preferencesRepository;

  final AppDatabase _db;
  final AccountsRepository _accounts;
  final CategoriesRepository _categories;
  final TransactionsRepository _transactions;
  final TransfersRepository _transfers;
  final PreferencesRepository _preferences;

  Future<void> initializeStandardDefaults() async {
    await _db.transaction(() async {
      await _preferences.resetToDefaults(
        isDemoMode: false,
        hasSeenFirstRunPrompt: true,
      );
      await _accounts.ensureDefaultAccounts();
      await _categories.ensureDefaultCategories();
    });
  }

  Future<void> enterDemoMode() async {
    await _db.transaction(() async {
      await _wipeAllTables();

      await _preferences.resetToDefaults(
        isDemoMode: true,
        hasSeenFirstRunPrompt: true,
      );

      final savingsId = await _accounts.createAccount(
        name: 'Savings',
        type: AccountType.bank,
        openingBalance: 0,
      );
      final cardId = await _accounts.createAccount(
        name: 'Credit Card',
        type: AccountType.creditCard,
        openingBalance: 0,
        creditLimit: 500000,
        billingStartDay: 1,
        dueDay: 25,
      );

      final defaults = await _categories.ensureDefaultCategories();
      final foodCategoryId = await _categories.createCategory(
        name: 'Food',
        color: 0xFFF44336,
        icon: 0xe56c,
        isIncome: false,
      );
      final salaryCategoryId = await _categories.createCategory(
        name: 'Salary',
        color: 0xFF4CAF50,
        icon: 0xe227,
        isIncome: true,
      );

      final now = DateTime.now();
      await _transactions.addTransaction(
        accountId: savingsId,
        amount: 250000,
        type: TransactionType.income,
        categoryId: salaryCategoryId,
        note: 'Monthly salary',
        date: DateTime(now.year, now.month, now.day).subtract(
          const Duration(days: 8),
        ),
      );
      await _transactions.addTransaction(
        accountId: savingsId,
        amount: 24000,
        type: TransactionType.expense,
        categoryId: foodCategoryId,
        note: 'Groceries',
        date: DateTime(now.year, now.month, now.day).subtract(
          const Duration(days: 3),
        ),
      );
      await _transactions.addTransaction(
        accountId: cardId,
        amount: 56000,
        type: TransactionType.expense,
        categoryId: foodCategoryId,
        note: 'Restaurant',
        date: DateTime(now.year, now.month, now.day).subtract(
          const Duration(days: 2),
        ),
      );

      await _transfers.createTransfer(
        fromAccountId: savingsId,
        toAccountId: cardId,
        amount: 30000,
        date: DateTime(now.year, now.month, now.day).subtract(
          const Duration(days: 1),
        ),
      );

      await _transactions.addTransaction(
        accountId: savingsId,
        amount: 10000,
        type: TransactionType.expense,
        categoryId: defaults.expenseId,
        note: 'Uncategorized expense',
        date: DateTime(now.year, now.month, now.day),
      );
    });
  }

  Future<void> exitDemoMode() async {
    await _db.transaction(() async {
      await _wipeAllTables();
      await _preferences.resetToDefaults(
        isDemoMode: false,
        hasSeenFirstRunPrompt: true,
      );
      await _accounts.ensureDefaultAccounts();
      await _categories.ensureDefaultCategories();
    });
  }

  Future<void> _wipeAllTables() async {
    await (_db.delete(_db.transfers)).go();
    await (_db.delete(_db.loanPayments)).go();
    await (_db.delete(_db.loanInstallments)).go();
    await (_db.delete(_db.loans)).go();
    await (_db.delete(_db.transactions)).go();

    await (_db.update(_db.categories)).write(
      const CategoriesCompanion(parentId: Value(null)),
    );
    await (_db.delete(_db.categories)).go();
    await (_db.delete(_db.accounts)).go();
  }
}
