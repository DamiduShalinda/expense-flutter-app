import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';

void main() {
  late AppDatabase db;
  late AccountsRepository accounts;
  late TransactionsRepository transactions;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    accounts = AccountsRepository(db);
    transactions = TransactionsRepository(db, accountsRepository: accounts);
  });

  tearDown(() async {
    await db.close();
  });

  test('Archiving hides account from active watch', () async {
    final id = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 0,
    );

    final seen = <List<Account>>[];
    final sub = accounts.watchActiveAccounts().listen(seen.add);
    addTearDown(sub.cancel);

    await Future<void>.delayed(Duration.zero);
    expect(seen.last.any((a) => a.id == id), isTrue);

    await accounts.setArchived(accountId: id, isArchived: true);
    await Future<void>.delayed(Duration.zero);

    expect(seen.last.any((a) => a.id == id), isFalse);
  });

  test('Deleting an account with transactions throws', () async {
    final id = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 0,
    );
    await transactions.addTransaction(
      accountId: id,
      amount: 10,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 1),
    );

    await expectLater(accounts.deleteAccount(id), throwsA(isA<StateError>()));
  });
}
