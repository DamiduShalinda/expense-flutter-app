part of '../database/app_database.dart';

class LoanInstallments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get loanId => integer().references(Loans, #id)();

  IntColumn get installmentNumber => integer()();

  DateTimeColumn get dueDate => dateTime()();

  IntColumn get principalDue => integer()();

  IntColumn get interestDue => integer()();

  IntColumn get totalDue => integer()();

  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
}
