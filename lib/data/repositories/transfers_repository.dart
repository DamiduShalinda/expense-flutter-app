import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/domain/services/balance_calculator.dart';

class TransfersRepository {
  TransfersRepository(
    this._db, {
    AccountsRepository? accountsRepository,
    BalanceCalculator? calculator,
  }) : _accounts = accountsRepository ?? AccountsRepository(_db),
       _calculator = calculator ?? const BalanceCalculator();

  final AppDatabase _db;
  final AccountsRepository _accounts;
  final BalanceCalculator _calculator;

  Future<int> createTransfer({
    required int fromAccountId,
    required int toAccountId,
    required int amount,
    required DateTime date,
  }) async {
    if (fromAccountId == toAccountId) {
      throw ArgumentError.value(toAccountId, 'toAccountId', 'Must differ');
    }
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }

    return _db.transaction(() async {
      final fromAccount = await _accounts.requireAccount(fromAccountId);
      final toAccount = await _accounts.requireAccount(toAccountId);

      final fromDelta = _calculator.transferDelta(
        accountType: fromAccount.type,
        isIncoming: false,
        amount: amount,
      );
      final toDelta = _calculator.transferDelta(
        accountType: toAccount.type,
        isIncoming: true,
        amount: amount,
      );

      final outgoingTransactionId = await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amount: amount,
              type: TransactionType.transfer,
              accountId: fromAccountId,
              categoryId: const Value(null),
              note: const Value(null),
              date: date,
              isPending: const Value(false),
            ),
          );

      final incomingTransactionId = await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amount: amount,
              type: TransactionType.transfer,
              accountId: toAccountId,
              categoryId: const Value(null),
              note: const Value(null),
              date: date,
              isPending: const Value(false),
            ),
          );

      final transferId = await _db
          .into(_db.transfers)
          .insert(
            TransfersCompanion.insert(
              fromAccountId: fromAccountId,
              toAccountId: toAccountId,
              amount: amount,
              date: date,
              linkedTransactionIds: Value(
                jsonEncode([outgoingTransactionId, incomingTransactionId]),
              ),
            ),
          );

      await _accounts.applyDelta(accountId: fromAccountId, delta: fromDelta);
      await _accounts.applyDelta(accountId: toAccountId, delta: toDelta);

      return transferId;
    });
  }

  Future<void> importTransfer({
    required int id,
    required int fromAccountId,
    required int toAccountId,
    required int amount,
    required DateTime date,
    required String linkedTransactionIds,
  }) async {
    if (fromAccountId == toAccountId) {
      throw ArgumentError.value(toAccountId, 'toAccountId', 'Must differ');
    }
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }

    await _db.into(_db.transfers).insert(
      TransfersCompanion(
        id: Value(id),
        fromAccountId: Value(fromAccountId),
        toAccountId: Value(toAccountId),
        amount: Value(amount),
        date: Value(date),
        linkedTransactionIds: Value(linkedTransactionIds),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Stream<List<Transfer>> watchTransfers({
    required DateTime start,
    required DateTime end,
  }) {
    final query = _db.select(_db.transfers)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<void> deleteTransfer(int transferId) async {
    await _db.transaction(() async {
      final transfer =
          await (_db.select(_db.transfers)
                ..where((t) => t.id.equals(transferId))
                ..limit(1))
              .getSingleOrNull();
      if (transfer == null) {
        throw StateError('Transfer not found: $transferId');
      }

      final outgoingTransactionId = _tryReadLinkedId(transfer, index: 0);
      final incomingTransactionId = _tryReadLinkedId(transfer, index: 1);

      final fromAccount = await _accounts.requireAccount(
        transfer.fromAccountId,
      );
      final toAccount = await _accounts.requireAccount(transfer.toAccountId);

      final fromDelta = _calculator.transferDelta(
        accountType: fromAccount.type,
        isIncoming: false,
        amount: transfer.amount,
      );
      final toDelta = _calculator.transferDelta(
        accountType: toAccount.type,
        isIncoming: true,
        amount: transfer.amount,
      );

      await _accounts.applyDelta(
        accountId: transfer.fromAccountId,
        delta: -fromDelta,
      );
      await _accounts.applyDelta(
        accountId: transfer.toAccountId,
        delta: -toDelta,
      );

      await (_db.delete(_db.transactions)..where(
            (t) => t.id.isIn([outgoingTransactionId, incomingTransactionId]),
          ))
          .go();
      await (_db.delete(
        _db.transfers,
      )..where((t) => t.id.equals(transferId))).go();
    });
  }

  int _tryReadLinkedId(Transfer transfer, {required int index}) {
    try {
      final decoded = jsonDecode(transfer.linkedTransactionIds);
      if (decoded is! List || decoded.length <= index) {
        throw const FormatException(
          'linkedTransactionIds must be a 2-item list',
        );
      }
      final value = decoded[index];
      if (value is! int) {
        throw const FormatException('linkedTransactionIds must contain ints');
      }
      return value;
    } catch (e) {
      throw StateError(
        'Invalid linkedTransactionIds for transfer ${transfer.id}',
      );
    }
  }
}
