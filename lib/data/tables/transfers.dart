part of '../database/app_database.dart';

class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('outgoingTransfers')
  IntColumn get fromAccountId => integer().references(Accounts, #id)();

  @ReferenceName('incomingTransfers')
  IntColumn get toAccountId => integer().references(Accounts, #id)();

  IntColumn get amount => integer()();

  DateTimeColumn get date => dateTime()();

  TextColumn get linkedTransactionIds =>
      text().withDefault(const Constant('[]'))();
}
