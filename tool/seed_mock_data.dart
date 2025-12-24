import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final accountsRepo = AccountsRepository(db);
  final categoriesRepo = CategoriesRepository(db);
  final transactionsRepo = TransactionsRepository(
    db,
    accountsRepository: accountsRepo,
  );
  final transfersRepo = TransfersRepository(
    db,
    accountsRepository: accountsRepo,
  );

  try {
    final cashId = await accountsRepo.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 50000,
    );
    final bankId = await accountsRepo.createAccount(
      name: 'Main Bank',
      type: AccountType.bank,
      openingBalance: 250000,
    );
    final cardId = await accountsRepo.createAccount(
      name: 'Credit Card',
      type: AccountType.creditCard,
      openingBalance: 0,
      creditLimit: 200000,
      billingStartDay: 1,
      dueDay: 25,
    );

    final foodCategoryId = await categoriesRepo.createCategory(
      name: 'Food',
      color: 0xFFF44336,
      icon: 0xe56c,
      isIncome: false,
    );
    final travelCategoryId = await categoriesRepo.createCategory(
      name: 'Travel',
      color: 0xFF2196F3,
      icon: 0xe071,
      isIncome: false,
    );
    final salaryCategoryId = await categoriesRepo.createCategory(
      name: 'Salary',
      color: 0xFF4CAF50,
      icon: 0xe227,
      isIncome: true,
    );

    final now = DateTime.now();
    await transactionsRepo.addTransaction(
      accountId: bankId,
      amount: 150000,
      type: TransactionType.income,
      categoryId: salaryCategoryId,
      note: 'Monthly salary',
      date: now.subtract(const Duration(days: 2)),
    );
    await transactionsRepo.addTransaction(
      accountId: cashId,
      amount: 12000,
      type: TransactionType.expense,
      categoryId: foodCategoryId,
      note: 'Groceries',
      date: now.subtract(const Duration(days: 1)),
    );
    await transactionsRepo.addTransaction(
      accountId: bankId,
      amount: 30000,
      type: TransactionType.expense,
      categoryId: travelCategoryId,
      note: 'Fuel',
      date: now.subtract(const Duration(days: 4)),
    );
    await transactionsRepo.addTransaction(
      accountId: cardId,
      amount: 45000,
      type: TransactionType.expense,
      categoryId: travelCategoryId,
      note: 'Hotel',
      date: now.subtract(const Duration(days: 6)),
    );

    await transfersRepo.createTransfer(
      fromAccountId: bankId,
      toAccountId: cashId,
      amount: 20000,
      date: now.subtract(const Duration(days: 3)),
    );

    stdout.writeln('Mock data inserted successfully.');
  } catch (e) {
    stderr.writeln('Failed to insert mock data: $e');
    exitCode = 1;
  } finally {
    await db.close();
  }
}
