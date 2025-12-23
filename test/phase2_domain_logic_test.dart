import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';

void main() {
  late AppDatabase db;
  late AccountsRepository accounts;
  late TransactionsRepository transactions;
  late TransfersRepository transfers;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    accounts = AccountsRepository(db);
    transactions = TransactionsRepository(db, accountsRepository: accounts);
    transfers = TransfersRepository(db, accountsRepository: accounts);
  });

  tearDown(() async {
    await db.close();
  });

  test('Income/expense updates currentBalance (pending excluded)', () async {
    final cashId = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 1000,
    );

    final expenseId = await transactions.addTransaction(
      accountId: cashId,
      amount: 200,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 1),
    );
    expect((await accounts.requireAccount(cashId)).currentBalance, 800);

    final pendingExpenseId = await transactions.addTransaction(
      accountId: cashId,
      amount: 50,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 1),
      isPending: true,
    );
    expect((await accounts.requireAccount(cashId)).currentBalance, 800);

    await transactions.deleteTransaction(pendingExpenseId);
    expect((await accounts.requireAccount(cashId)).currentBalance, 800);

    await transactions.deleteTransaction(expenseId);
    expect((await accounts.requireAccount(cashId)).currentBalance, 1000);

    await accounts.recalculateAndPersistCurrentBalance(cashId);
    expect((await accounts.requireAccount(cashId)).currentBalance, 1000);
  });

  test('Credit card: expense increases debt, income decreases debt', () async {
    final creditCardId = await accounts.createAccount(
      name: 'Visa',
      type: AccountType.creditCard,
      openingBalance: 0,
      creditLimit: 5000,
    );

    await transactions.addTransaction(
      accountId: creditCardId,
      amount: 1000,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 1),
    );
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 1000);

    await transactions.addTransaction(
      accountId: creditCardId,
      amount: 200,
      type: TransactionType.income,
      date: DateTime(2025, 1, 2),
    );
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 800);

    await accounts.recalculateAndPersistCurrentBalance(creditCardId);
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 800);
  });

  test('Transfer creates two transactions and updates both balances', () async {
    final cashId = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 1000,
    );
    final creditCardId = await accounts.createAccount(
      name: 'Visa',
      type: AccountType.creditCard,
      openingBalance: 0,
      creditLimit: 5000,
    );

    await transactions.addTransaction(
      accountId: creditCardId,
      amount: 800,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 1),
    );
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 800);

    final transferId = await transfers.createTransfer(
      fromAccountId: cashId,
      toAccountId: creditCardId,
      amount: 300,
      date: DateTime(2025, 1, 3),
    );

    expect((await accounts.requireAccount(cashId)).currentBalance, 700);
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 500);

    await accounts.recalculateAndPersistCurrentBalance(cashId);
    await accounts.recalculateAndPersistCurrentBalance(creditCardId);
    expect((await accounts.requireAccount(cashId)).currentBalance, 700);
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 500);

    await transfers.deleteTransfer(transferId);
    expect((await accounts.requireAccount(cashId)).currentBalance, 1000);
    expect((await accounts.requireAccount(creditCardId)).currentBalance, 800);
  });

  test('Credit limit is enforced for debt-increasing operations', () async {
    final cashId = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 1000,
    );
    final creditCardId = await accounts.createAccount(
      name: 'LowLimit',
      type: AccountType.creditCard,
      openingBalance: 0,
      creditLimit: 500,
    );

    await expectLater(
      transactions.addTransaction(
        accountId: creditCardId,
        amount: 600,
        type: TransactionType.expense,
        date: DateTime(2025, 1, 1),
      ),
      throwsA(isA<StateError>()),
    );

    await expectLater(
      transfers.createTransfer(
        fromAccountId: creditCardId,
        toAccountId: cashId,
        amount: 600,
        date: DateTime(2025, 1, 2),
      ),
      throwsA(isA<StateError>()),
    );
  });
}
