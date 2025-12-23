import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';

class PreferencesRepository {
  PreferencesRepository(this._db);

  final AppDatabase _db;

  Stream<Preference> watchPreferences() {
    return _ensurePreferencesRow().asStream().asyncExpand((_) {
      return (_db.select(_db.preferences)..limit(1)).watchSingle();
    });
  }

  Future<Preference> getPreferences() async {
    await _ensurePreferencesRow();
    return (_db.select(_db.preferences)..limit(1)).getSingle();
  }

  Future<void> setCurrencyCode(String currencyCode) async {
    final code = currencyCode.trim().toUpperCase();
    if (code.isEmpty) {
      throw ArgumentError.value(currencyCode, 'currencyCode');
    }
    final pref = await getPreferences();
    await (_db.update(_db.preferences)..where((p) => p.id.equals(pref.id)))
        .write(PreferencesCompanion(currencyCode: Value(code)));
  }

  Future<void> setFirstDayOfWeek(int weekday) async {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) {
      throw ArgumentError.value(weekday, 'weekday');
    }
    final pref = await getPreferences();
    await (_db.update(_db.preferences)..where((p) => p.id.equals(pref.id)))
        .write(PreferencesCompanion(firstDayOfWeek: Value(weekday)));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final pref = await getPreferences();
    await (_db.update(_db.preferences)..where((p) => p.id.equals(pref.id)))
        .write(PreferencesCompanion(themeMode: Value(mode)));
  }

  Future<int> _ensurePreferencesRow() async {
    final existing = await (_db.select(
      _db.preferences,
    )..limit(1)).getSingleOrNull();
    if (existing != null) return existing.id;
    return _db.into(_db.preferences).insert(const PreferencesCompanion());
  }
}
