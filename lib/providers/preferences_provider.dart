import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final preferencesProvider =
    NotifierProvider.autoDispose<PreferencesNotifier, AsyncValue<Preference>>(
      PreferencesNotifier.new,
    );

class PreferencesNotifier extends AutoDisposeNotifier<AsyncValue<Preference>> {
  StreamSubscription<Preference>? _sub;

  @override
  AsyncValue<Preference> build() {
    final repo = ref.watch(preferencesRepositoryProvider);
    _sub = repo.watchPreferences().listen(
      (pref) => state = AsyncData(pref),
      onError: (Object error, StackTrace st) => state = AsyncError(error, st),
    );
    ref.onDispose(() => _sub?.cancel());
    return const AsyncLoading();
  }

  Future<void> setCurrencyCode(String currencyCode) async {
    await ref.read(preferencesRepositoryProvider).setCurrencyCode(currencyCode);
  }

  Future<void> setFirstDayOfWeek(int weekday) async {
    await ref.read(preferencesRepositoryProvider).setFirstDayOfWeek(weekday);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await ref.read(preferencesRepositoryProvider).setThemeMode(mode);
  }
}

final themeModeProvider = Provider.autoDispose<AsyncValue<ThemeMode>>((ref) {
  final prefAsync = ref.watch(preferencesProvider);
  return prefAsync.whenData((pref) {
    return switch (pref.themeMode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  });
});

final currencyCodeProvider = Provider.autoDispose<AsyncValue<String>>((ref) {
  final prefAsync = ref.watch(preferencesProvider);
  return prefAsync.whenData((pref) => pref.currencyCode);
});

final firstDayOfWeekProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  final prefAsync = ref.watch(preferencesProvider);
  return prefAsync.whenData((pref) => pref.firstDayOfWeek);
});
