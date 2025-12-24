part of '../database/app_database.dart';

class LoanPayments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get loanId => integer().references(Loans, #id)();

  IntColumn get installmentId => integer().references(LoanInstallments, #id)();

  IntColumn get transactionId => integer().references(Transactions, #id)();

  IntColumn get amount => integer()();

  IntColumn get principalPart => integer()();

  IntColumn get interestPart => integer()();

  DateTimeColumn get date => dateTime()();
}
