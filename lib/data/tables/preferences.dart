part of '../database/app_database.dart';

class Preferences extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  IntColumn get firstDayOfWeek =>
      integer().withDefault(const Constant(DateTime.monday))();

  TextColumn get themeMode =>
      textEnum<AppThemeMode>().withDefault(const Constant('system'))();
}
