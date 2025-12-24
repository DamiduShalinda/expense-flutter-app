import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/domain/services/balance_calculator.dart';

class TransactionsRepository {
  TransactionsRepository(
    this._db, {
    AccountsRepository? accountsRepository,
    BalanceCalculator? calculator,
  }) : _accounts = accountsRepository ?? AccountsRepository(_db),
       _calculator = calculator ?? const BalanceCalculator();

  final AppDatabase _db;
  final AccountsRepository _accounts;
  final BalanceCalculator _calculator;

  Future<int> addTransaction({
    required int accountId,
    required int amount,
    required TransactionType type,
    int? categoryId,
    String? note,
    required DateTime date,
    bool isPending = false,
  }) async {
    if (type == TransactionType.transfer) {
      throw ArgumentError.value(type, 'type', 'Use TransfersRepository');
    }
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }

    return _db.transaction(() async {
      final transactionId = await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amount: amount,
              type: type,
              accountId: accountId,
              categoryId: Value(categoryId),
              note: Value(note),
              date: date,
              isPending: Value(isPending),
            ),
          );

      if (!isPending) {
        final account = await _accounts.requireAccount(accountId);
        final delta = _calculator.nonTransferDelta(
          accountType: account.type,
          transactionType: type,
          amount: amount,
        );
        await _accounts.applyDelta(accountId: accountId, delta: delta);
      }

      return transactionId;
    });
  }

  Future<void> importTransaction({
    required int id,
    required int amount,
    required TransactionType type,
    required int accountId,
    int? categoryId,
    String? note,
    required DateTime date,
    required bool isPending,
  }) async {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }

    await _db.into(_db.transactions).insert(
      TransactionsCompanion(
        id: Value(id),
        amount: Value(amount),
        type: Value(type),
        accountId: Value(accountId),
        categoryId: Value(categoryId),
        note: Value(note),
        date: Value(date),
        isPending: Value(isPending),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Stream<List<Transaction>> watchTransactions({
    required DateTime start,
    required DateTime end,
    int? accountId,
    int? categoryId,
  }) {
    final query = _db.select(_db.transactions)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);

    if (accountId != null) {
      query.where((t) => t.accountId.equals(accountId));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    return query.watch();
  }

  Future<void> deleteTransaction(int transactionId) async {
    await _db.transaction(() async {
      final tx =
          await (_db.select(_db.transactions)
                ..where((t) => t.id.equals(transactionId))
                ..limit(1))
              .getSingleOrNull();

      if (tx == null) {
        throw StateError('Transaction not found: $transactionId');
      }
      if (tx.type == TransactionType.transfer) {
        throw StateError('Use TransfersRepository to delete transfer records');
      }

      await (_db.delete(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).go();

      if (!tx.isPending) {
        final account = await _accounts.requireAccount(tx.accountId);
        final delta = _calculator.nonTransferDelta(
          accountType: account.type,
          transactionType: tx.type,
          amount: tx.amount,
        );
        await _accounts.applyDelta(accountId: tx.accountId, delta: -delta);
      }
    });
  }
}
