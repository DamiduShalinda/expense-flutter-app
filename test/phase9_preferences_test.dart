import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/preferences_repository.dart';
import 'package:expense_manage/providers/dashboard_provider.dart';

void main() {
  test('Preferences default row is created and can be updated', () async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);

    final repo = PreferencesRepository(db);
    final pref = await repo.getPreferences();
    expect(pref.currencyCode, 'USD');
    expect(pref.firstDayOfWeek, DateTime.monday);
    expect(pref.themeMode, AppThemeMode.system);

    await repo.setCurrencyCode('lkr');
    await repo.setFirstDayOfWeek(DateTime.sunday);
    await repo.setThemeMode(AppThemeMode.dark);

    final updated = await repo.getPreferences();
    expect(updated.currencyCode, 'LKR');
    expect(updated.firstDayOfWeek, DateTime.sunday);
    expect(updated.themeMode, AppThemeMode.dark);
  });

  test('startOfWeek respects configured first day', () {
    final date = DateTime(2025, 1, 8); // Wednesday
    expect(
      startOfWeek(date, firstDayOfWeek: DateTime.monday),
      DateTime(2025, 1, 6),
    );
    expect(
      startOfWeek(date, firstDayOfWeek: DateTime.sunday),
      DateTime(2025, 1, 5),
    );
  });
}
