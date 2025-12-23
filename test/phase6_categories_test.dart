import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';

void main() {
  late AppDatabase db;
  late CategoriesRepository categories;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    categories = CategoriesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'Deleting a used category reassigns transactions to Uncategorized',
    () async {
      final defaults = await categories.ensureDefaultCategories();

      final foodId = await categories.createCategory(
        name: 'Food',
        parentId: null,
        color: 0xFFFF0000,
        icon: 123,
        isIncome: false,
      );

      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              name: 'Cash',
              type: AccountType.cash,
              openingBalance: 0,
              currentBalance: 0,
            ),
          );

      final txId = await db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amount: 10,
              type: TransactionType.expense,
              accountId: accountId,
              categoryId: Value(foodId),
              note: const Value(null),
              date: DateTime(2025, 1, 1),
              isPending: const Value(false),
            ),
          );

      await categories.deleteCategory(foodId);

      final tx = await (db.select(
        db.transactions,
      )..where((t) => t.id.equals(txId))).getSingle();
      expect(tx.categoryId, defaults.expenseId);

      final deleted = await (db.select(
        db.categories,
      )..where((c) => c.id.equals(foodId))).getSingleOrNull();
      expect(deleted, isNull);
    },
  );

  test('Uncategorized category cannot be deleted', () async {
    final defaults = await categories.ensureDefaultCategories();
    await expectLater(
      categories.deleteCategory(defaults.expenseId),
      throwsA(isA<StateError>()),
    );
  });
}
