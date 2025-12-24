import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/domain/services/balance_calculator.dart';

class AccountsRepository {
  AccountsRepository(this._db, {BalanceCalculator? calculator})
    : _calculator = calculator ?? const BalanceCalculator();

  final AppDatabase _db;
  final BalanceCalculator _calculator;

  Future<int> createAccount({
    required String name,
    required AccountType type,
    required int openingBalance,
    int? creditLimit,
    int? billingStartDay,
    int? dueDay,
  }) async {
    if (openingBalance < 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Must be >= 0',
      );
    }

    return _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion.insert(
            name: name,
            type: type,
            openingBalance: openingBalance,
            currentBalance: openingBalance,
            creditLimit: Value(creditLimit),
            billingStartDay: Value(billingStartDay),
            dueDay: Value(dueDay),
          ),
        );
  }

  Future<void> importAccount({
    required int id,
    required String name,
    required AccountType type,
    required int openingBalance,
    required int currentBalance,
    int? creditLimit,
    int? billingStartDay,
    int? dueDay,
    required bool isArchived,
  }) async {
    if (openingBalance < 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Must be >= 0',
      );
    }

    await _db.into(_db.accounts).insert(
      AccountsCompanion(
        id: Value(id),
        name: Value(name),
        type: Value(type),
        openingBalance: Value(openingBalance),
        currentBalance: Value(currentBalance),
        creditLimit: Value(creditLimit),
        billingStartDay: Value(billingStartDay),
        dueDay: Value(dueDay),
        isArchived: Value(isArchived),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Stream<List<Account>> watchActiveAccounts() {
    return (_db.select(_db.accounts)
          ..where((a) => a.isArchived.equals(false))
          ..orderBy([
            (a) => OrderingTerm(expression: a.name),
            (a) => OrderingTerm(expression: a.id),
          ]))
        .watch();
  }

  Future<bool> hasTransactions(int accountId) async {
    final countExpr = _db.transactions.id.count();
    final row =
        await (_db.selectOnly(_db.transactions)
              ..addColumns([countExpr])
              ..where(_db.transactions.accountId.equals(accountId)))
            .getSingle();
    return (row.read(countExpr) ?? 0) > 0;
  }

  Future<void> updateAccount({
    required int accountId,
    required String name,
    required AccountType type,
    required int openingBalance,
    int? creditLimit,
    int? billingStartDay,
    int? dueDay,
  }) async {
    if (openingBalance < 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Must be >= 0',
      );
    }

    await _db.transaction(() async {
      await (_db.update(
        _db.accounts,
      )..where((a) => a.id.equals(accountId))).write(
        AccountsCompanion(
          name: Value(name),
          type: Value(type),
          openingBalance: Value(openingBalance),
          creditLimit: Value(creditLimit),
          billingStartDay: Value(billingStartDay),
          dueDay: Value(dueDay),
        ),
      );

      await recalculateAndPersistCurrentBalance(accountId);
    });
  }

  Future<void> setArchived({
    required int accountId,
    required bool isArchived,
  }) async {
    await (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(isArchived: Value(isArchived)));
  }

  Future<void> deleteAccount(int accountId) async {
    final hasTx = await hasTransactions(accountId);
    if (hasTx) {
      throw StateError('Cannot delete account with transactions: $accountId');
    }

    await (_db.delete(_db.accounts)..where((a) => a.id.equals(accountId))).go();
  }

  Future<Account> requireAccount(int accountId) async {
    final account =
        await (_db.select(_db.accounts)
              ..where((a) => a.id.equals(accountId))
              ..limit(1))
            .getSingleOrNull();
    if (account == null) {
      throw StateError('Account not found: $accountId');
    }
    return account;
  }

  Future<void> applyDelta({required int accountId, required int delta}) async {
    if (delta == 0) return;

    final account = await requireAccount(accountId);
    final nextBalance = account.currentBalance + delta;

    if (account.type == AccountType.creditCard &&
        delta > 0 &&
        account.creditLimit != null &&
        nextBalance > account.creditLimit!) {
      throw StateError('Credit limit exceeded for account $accountId');
    }

    await (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(currentBalance: Value(nextBalance)));
  }

  Future<int> computeCurrentBalance(int accountId) async {
    final account = await requireAccount(accountId);

    final incomeSum = await _sumTransactionsAmount(
      accountId: accountId,
      type: TransactionType.income,
    );
    final expenseSum = await _sumTransactionsAmount(
      accountId: accountId,
      type: TransactionType.expense,
    );

    final outgoingTransfers = await _sumTransfersAmount(
      accountId: accountId,
      isIncoming: false,
    );
    final incomingTransfers = await _sumTransfersAmount(
      accountId: accountId,
      isIncoming: true,
    );

    final nonTransferNet =
        _calculator.nonTransferDelta(
          accountType: account.type,
          transactionType: TransactionType.income,
          amount: incomeSum,
        ) +
        _calculator.nonTransferDelta(
          accountType: account.type,
          transactionType: TransactionType.expense,
          amount: expenseSum,
        );

    final transferNet =
        _calculator.transferDelta(
          accountType: account.type,
          isIncoming: true,
          amount: incomingTransfers,
        ) +
        _calculator.transferDelta(
          accountType: account.type,
          isIncoming: false,
          amount: outgoingTransfers,
        );

    return account.openingBalance + nonTransferNet + transferNet;
  }

  Future<void> recalculateAndPersistCurrentBalance(int accountId) async {
    final account = await requireAccount(accountId);
    final nextBalance = await computeCurrentBalance(accountId);

    if (account.type == AccountType.creditCard &&
        account.creditLimit != null &&
        nextBalance > account.creditLimit!) {
      throw StateError('Credit limit exceeded for account $accountId');
    }

    await (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(currentBalance: Value(nextBalance)));
  }

  Future<int> _sumTransactionsAmount({
    required int accountId,
    required TransactionType type,
  }) async {
    final sumExpr = _db.transactions.amount.sum();

    final row =
        await (_db.selectOnly(_db.transactions)
              ..addColumns([sumExpr])
              ..where(_db.transactions.accountId.equals(accountId))
              ..where(_db.transactions.type.equalsValue(type))
              ..where(_db.transactions.isPending.equals(false)))
            .getSingle();

    return row.read(sumExpr) ?? 0;
  }

  Future<int> _sumTransfersAmount({
    required int accountId,
    required bool isIncoming,
  }) async {
    final sumExpr = _db.transfers.amount.sum();
    final query = _db.selectOnly(_db.transfers)..addColumns([sumExpr]);
    if (isIncoming) {
      query.where(_db.transfers.toAccountId.equals(accountId));
    } else {
      query.where(_db.transfers.fromAccountId.equals(accountId));
    }

    final row = await query.getSingle();
    return row.read(sumExpr) ?? 0;
  }
}
