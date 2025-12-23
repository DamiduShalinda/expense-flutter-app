part of '../database/app_database.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get amount => integer()();

  TextColumn get type => textEnum<TransactionType>()();

  IntColumn get accountId => integer().references(Accounts, #id)();

  IntColumn get categoryId => integer().nullable().references(Categories, #id)();

  TextColumn get note => text().nullable()();

  DateTimeColumn get date => dateTime()();

  BoolColumn get isPending => boolean().withDefault(const Constant(false))();
}

