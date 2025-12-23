part of '../database/app_database.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<AccountType>()();

  IntColumn get openingBalance => integer()();

  IntColumn get currentBalance => integer()();

  IntColumn get creditLimit => integer().nullable()();

  IntColumn get billingStartDay => integer().nullable()();

  IntColumn get dueDay => integer().nullable()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}
