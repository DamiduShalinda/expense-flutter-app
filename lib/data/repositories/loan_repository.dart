import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/domain/services/loan_schedule_generator.dart';

class LoanRepository {
  LoanRepository(this._db);

  final AppDatabase _db;

  Future<int> createLoan({
    required String name,
    required int accountId,
    int? disbursementTransactionId,
    required int principalAmount,
    required double interestRate,
    required LoanInterestType interestType,
    required int durationMonths,
    required int paymentDay,
    required int totalPayableAmount,
    required int monthlyInstallment,
    required int outstandingAmount,
    required List<LoanInstallmentDraft> schedule,
  }) async {
    if (schedule.length != durationMonths) {
      throw ArgumentError.value(schedule.length, 'schedule');
    }

    return _db.transaction(() async {
      final loanId = await _db.into(_db.loans).insert(
        LoansCompanion.insert(
          name: name.trim(),
          accountId: accountId,
          disbursementTransactionId: Value(disbursementTransactionId),
          principalAmount: principalAmount,
          interestRate: interestRate,
          interestType: interestType,
          durationMonths: durationMonths,
          paymentDay: paymentDay,
          totalPayableAmount: totalPayableAmount,
          monthlyInstallment: monthlyInstallment,
          outstandingAmount: outstandingAmount,
          isClosed: const Value(false),
        ),
      );

      await _db.batch((batch) {
        batch.insertAll(
          _db.loanInstallments,
          schedule
              .map((item) {
                final principalDue = item.principalDue.round();
                final interestDue = item.interestDue.round();
                return LoanInstallmentsCompanion.insert(
                  loanId: loanId,
                  installmentNumber: item.installmentNumber,
                  dueDate: item.dueDate,
                  principalDue: principalDue,
                  interestDue: interestDue,
                  totalDue: principalDue + interestDue,
                  isPaid: const Value(false),
                );
              })
              .toList(),
        );
      });

      return loanId;
    });
  }

  Stream<List<Loan>> watchActiveLoans() {
    return (_db.select(_db.loans)
          ..where((l) => l.isClosed.equals(false))
          ..orderBy([(l) => OrderingTerm(expression: l.id)]))
        .watch();
  }

  Stream<List<Loan>> watchClosedLoans() {
    return (_db.select(_db.loans)
          ..where((l) => l.isClosed.equals(true))
          ..orderBy([(l) => OrderingTerm(expression: l.id)]))
        .watch();
  }

  Future<Loan?> getLoanById(int loanId) async {
    return (_db.select(_db.loans)
          ..where((l) => l.id.equals(loanId))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<Loan?> watchLoan(int loanId) {
    return (_db.select(_db.loans)
          ..where((l) => l.id.equals(loanId))
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<LoanInstallment>> watchInstallments(int loanId) {
    return (_db.select(_db.loanInstallments)
          ..where((i) => i.loanId.equals(loanId))
          ..orderBy([
            (i) => OrderingTerm(expression: i.installmentNumber),
            (i) => OrderingTerm(expression: i.id),
          ]))
        .watch();
  }

  Future<void> updateOutstanding({
    required int loanId,
    required int outstandingAmount,
  }) async {
    await (_db.update(_db.loans)..where((l) => l.id.equals(loanId))).write(
      LoansCompanion(
        outstandingAmount: Value(outstandingAmount),
        isClosed: Value(outstandingAmount <= 0),
      ),
    );
  }

  Future<void> closeLoan(int loanId) async {
    await (_db.update(_db.loans)..where((l) => l.id.equals(loanId))).write(
      const LoansCompanion(isClosed: Value(true)),
    );
  }
}
