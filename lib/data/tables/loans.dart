part of '../database/app_database.dart';

class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get accountId => integer().references(Accounts, #id)();

  IntColumn get disbursementTransactionId =>
      integer().nullable().references(Transactions, #id)();

  IntColumn get principalAmount => integer()();

  RealColumn get interestRate => real()();

  TextColumn get interestType => textEnum<LoanInterestType>()();

  IntColumn get durationMonths => integer()();

  IntColumn get paymentDay => integer()();

  IntColumn get totalPayableAmount => integer()();

  IntColumn get monthlyInstallment => integer()();

  IntColumn get outstandingAmount => integer()();

  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
}
