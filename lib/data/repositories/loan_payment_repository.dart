import 'dart:math';

import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';

class LoanPaymentRepository {
  LoanPaymentRepository(
    this._db, {
    required TransactionsRepository transactionsRepository,
    required CategoriesRepository categoriesRepository,
  }) : _transactions = transactionsRepository,
       _categories = categoriesRepository;

  final AppDatabase _db;
  final TransactionsRepository _transactions;
  final CategoriesRepository _categories;

  Stream<List<LoanPayment>> watchPaymentsForLoan(int loanId) {
    final query = _db.select(_db.loanPayments).join([
      innerJoin(
        _db.transactions,
        _db.transactions.id.equalsExp(_db.loanPayments.transactionId),
      ),
    ])
      ..where(_db.loanPayments.loanId.equals(loanId))
      ..where(_db.transactions.isPending.equals(false))
      ..orderBy([
        OrderingTerm(
          expression: _db.loanPayments.date,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(expression: _db.loanPayments.id, mode: OrderingMode.desc),
      ]);

    return query.watch().map(
      (rows) =>
          rows.map((row) => row.readTable(_db.loanPayments)).toList(),
    );
  }

  Future<int> recordPayment({
    required int loanId,
    required int installmentId,
    required int accountId,
    required int amount,
    required DateTime date,
    bool isPending = false,
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be > 0');
    }

    return _db.transaction(() async {
      final loan =
          await (_db.select(_db.loans)
                ..where((l) => l.id.equals(loanId))
                ..limit(1))
              .getSingleOrNull();
      if (loan == null) {
        throw StateError('Loan not found: $loanId');
      }
      if (loan.isClosed) {
        throw StateError('Loan is already closed');
      }

      final installment =
          await (_db.select(_db.loanInstallments)
                ..where((i) => i.id.equals(installmentId))
                ..limit(1))
              .getSingleOrNull();
      if (installment == null || installment.loanId != loanId) {
        throw StateError('Installment not found for loan');
      }

      final paidPrincipalExpr = _db.loanPayments.principalPart.sum();
      final paidInterestExpr = _db.loanPayments.interestPart.sum();
      final paidQuery = _db.selectOnly(_db.loanPayments)
        ..addColumns([paidPrincipalExpr, paidInterestExpr])
        ..join([
          innerJoin(
            _db.transactions,
            _db.transactions.id.equalsExp(_db.loanPayments.transactionId),
          ),
        ])
        ..where(_db.loanPayments.installmentId.equals(installmentId))
        ..where(_db.transactions.isPending.equals(false));
      final paidRow = await paidQuery.getSingle();
      final paidPrincipal = paidRow.read(paidPrincipalExpr) ?? 0;
      final paidInterest = paidRow.read(paidInterestExpr) ?? 0;
      final remainingPrincipal = max(
        0,
        installment.principalDue - paidPrincipal,
      );
      final remainingInterest = max(0, installment.interestDue - paidInterest);
      final remainingTotal = remainingPrincipal + remainingInterest;

      if (amount > remainingTotal) {
        throw StateError('Payment exceeds remaining installment amount');
      }
      if (!isPending && amount > loan.outstandingAmount) {
        throw StateError('Payment exceeds remaining loan balance');
      }

      final interestPart = amount > remainingInterest
          ? remainingInterest
          : amount;
      final principalPart = amount - interestPart;

      await _categories.ensureDefaultCategories();
      final interestCategoryId = await _ensureLoanInterestCategory();
      final transactionId = await _transactions.addTransaction(
        accountId: accountId,
        amount: amount,
        type: TransactionType.expense,
        categoryId: interestCategoryId,
        note: 'Loan payment #${installment.installmentNumber}',
        date: date,
        isPending: isPending,
      );

      final paymentId = await _db.into(_db.loanPayments).insert(
        LoanPaymentsCompanion.insert(
          loanId: loanId,
          installmentId: installmentId,
          transactionId: transactionId,
          amount: amount,
          principalPart: principalPart,
          interestPart: interestPart,
          date: date,
        ),
      );

      if (!isPending) {
        final newTotalPaid = paidPrincipal + paidInterest + amount;
        final isPaid = newTotalPaid >= installment.totalDue;
        await (_db.update(_db.loanInstallments)
              ..where((i) => i.id.equals(installmentId)))
            .write(LoanInstallmentsCompanion(isPaid: Value(isPaid)));

        final newOutstanding = max(0, loan.outstandingAmount - amount);
        await (_db.update(_db.loans)..where((l) => l.id.equals(loanId))).write(
          LoansCompanion(
            outstandingAmount: Value(newOutstanding),
            isClosed: Value(newOutstanding <= 0),
          ),
        );
      }

      return paymentId;
    });
  }

  Future<int> _ensureLoanInterestCategory() async {
    final existing =
        await (_db.select(_db.categories)
              ..where((c) => c.name.equals('Loan Interest'))
              ..where((c) => c.isIncome.equals(false))
              ..where((c) => c.parentId.isNull())
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing.id;

    return _db.into(_db.categories).insert(
      CategoriesCompanion.insert(
        name: 'Loan Interest',
        parentId: const Value(null),
        color: 0xFFEF6C00,
        icon: 0xe88f,
        isIncome: const Value(false),
      ),
    );
  }
}
