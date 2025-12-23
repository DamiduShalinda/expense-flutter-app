import 'package:drift/drift.dart';

import 'package:expense_manage/data/database/app_database.dart';

class CategoriesRepository {
  CategoriesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Category>> watchAllCategories() {
    return (_db.select(_db.categories)..orderBy([
          (c) => OrderingTerm(expression: c.parentId),
          (c) => OrderingTerm(expression: c.name),
          (c) => OrderingTerm(expression: c.id),
        ]))
        .watch();
  }

  Future<_DefaultCategories> ensureDefaultCategories() async {
    Future<int> ensureOne({required bool isIncome}) async {
      final existing =
          await (_db.select(_db.categories)
                ..where((c) => c.name.equals('Uncategorized'))
                ..where((c) => c.isIncome.equals(isIncome))
                ..where((c) => c.parentId.isNull())
                ..limit(1))
              .getSingleOrNull();
      if (existing != null) return existing.id;

      return _db
          .into(_db.categories)
          .insert(
            CategoriesCompanion.insert(
              name: 'Uncategorized',
              parentId: const Value(null),
              color: 0xFF9E9E9E,
              icon: 0xe0f2,
              isIncome: Value(isIncome),
            ),
          );
    }

    final expenseId = await ensureOne(isIncome: false);
    final incomeId = await ensureOne(isIncome: true);
    return _DefaultCategories(expenseId: expenseId, incomeId: incomeId);
  }

  Future<int> createCategory({
    required String name,
    int? parentId,
    required int color,
    required int icon,
    required bool isIncome,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    }

    return _db
        .into(_db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: trimmed,
            parentId: Value(parentId),
            color: color,
            icon: icon,
            isIncome: Value(isIncome),
          ),
        );
  }

  Future<Category> requireCategory(int categoryId) async {
    final category =
        await (_db.select(_db.categories)
              ..where((c) => c.id.equals(categoryId))
              ..limit(1))
            .getSingleOrNull();
    if (category == null) {
      throw StateError('Category not found: $categoryId');
    }
    return category;
  }

  Future<void> updateCategory({
    required int categoryId,
    required String name,
    int? parentId,
    required int color,
    required int icon,
    required bool isIncome,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    }
    if (parentId == categoryId) {
      throw ArgumentError.value(
        parentId,
        'parentId',
        'Cannot parent to itself',
      );
    }

    await (_db.update(
      _db.categories,
    )..where((c) => c.id.equals(categoryId))).write(
      CategoriesCompanion(
        name: Value(trimmed),
        parentId: Value(parentId),
        color: Value(color),
        icon: Value(icon),
        isIncome: Value(isIncome),
      ),
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    await _db.transaction(() async {
      final category = await requireCategory(categoryId);
      final defaults = await ensureDefaultCategories();
      final protectedId = category.isIncome
          ? defaults.incomeId
          : defaults.expenseId;
      if (categoryId == protectedId) {
        throw StateError('Cannot delete Uncategorized category');
      }

      await (_db.update(_db.categories)
            ..where((c) => c.parentId.equals(categoryId)))
          .write(const CategoriesCompanion(parentId: Value(null)));

      final usedCountExpr = _db.transactions.id.count();
      final usedRow =
          await (_db.selectOnly(_db.transactions)
                ..addColumns([usedCountExpr])
                ..where(_db.transactions.categoryId.equals(categoryId)))
              .getSingle();
      final used = (usedRow.read(usedCountExpr) ?? 0) > 0;
      if (used) {
        await (_db.update(_db.transactions)
              ..where((t) => t.categoryId.equals(categoryId)))
            .write(TransactionsCompanion(categoryId: Value(protectedId)));
      }

      await (_db.delete(
        _db.categories,
      )..where((c) => c.id.equals(categoryId))).go();
    });
  }
}

class _DefaultCategories {
  const _DefaultCategories({required this.expenseId, required this.incomeId});

  final int expenseId;
  final int incomeId;
}
