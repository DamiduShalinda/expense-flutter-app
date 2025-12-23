// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/app.dart';
import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/database_provider.dart';

void main() {
  testWidgets('App shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) {
            final db = AppDatabase(executor: NativeDatabase.memory());
            ref.onDispose(() => db.close());
            return db;
          }),
        ],
        child: const ExpenseApp(),
      ),
    );

    expect(find.text('Dashboard'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
