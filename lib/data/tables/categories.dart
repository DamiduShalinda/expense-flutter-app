part of '../database/app_database.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get parentId => integer().nullable().references(Categories, #id)();

  IntColumn get color => integer()();

  IntColumn get icon => integer()();

  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
}

