import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/providers/accounts_provider.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/database_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';
import 'package:expense_manage/providers/transactions_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        accountsRepositoryProvider.overrideWith(
          (ref) => AccountsRepository(ref.watch(appDatabaseProvider)),
        ),
        categoriesRepositoryProvider.overrideWith(
          (ref) => CategoriesRepository(ref.watch(appDatabaseProvider)),
        ),
        transactionsRepositoryProvider.overrideWith(
          (ref) => TransactionsRepository(
            ref.watch(appDatabaseProvider),
            accountsRepository: ref.watch(accountsRepositoryProvider),
          ),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test(
    'activeAccountsProvider emits active accounts and totalBalance sums',
    () async {
      final accounts = container.read(accountsRepositoryProvider);
      await accounts.createAccount(
        name: 'Cash',
        type: AccountType.cash,
        openingBalance: 1000,
      );
      await accounts.createAccount(
        name: 'Bank',
        type: AccountType.bank,
        openingBalance: 2500,
      );

      final sub = container.listen(activeAccountsProvider, (_, __) {});
      addTearDown(sub.close);

      await Future<void>.delayed(Duration.zero);

      final accountsAsync = container.read(activeAccountsProvider);
      expect(accountsAsync.hasValue, isTrue);
      expect(accountsAsync.value!.length, 2);

      final totalAsync = container.read(totalBalanceProvider);
      expect(totalAsync.hasValue, isTrue);
      expect(totalAsync.value, 3500);
    },
  );

  test('categoriesByParentProvider groups by parentId', () async {
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: 'Food',
            parentId: const Value(null),
            color: 0,
            icon: 0,
            isIncome: const Value(false),
          ),
        );
    final parent = await (db.select(db.categories)..limit(1)).getSingle();
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: 'Groceries',
            parentId: Value(parent.id),
            color: 0,
            icon: 0,
            isIncome: const Value(false),
          ),
        );

    final sub = container.listen(categoriesByParentProvider, (_, __) {});
    addTearDown(sub.close);

    await Future<void>.delayed(Duration.zero);

    final groupedAsync = container.read(categoriesByParentProvider);
    expect(groupedAsync.hasValue, isTrue);
    final grouped = groupedAsync.value!;
    expect(grouped[null]!.single.name, 'Food');
    expect(grouped[parent.id]!.single.name, 'Groceries');
  });

  test('transactionsProvider filters by date and account', () async {
    final accounts = container.read(accountsRepositoryProvider);
    final transactions = container.read(transactionsRepositoryProvider);

    final cashId = await accounts.createAccount(
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 0,
    );
    final bankId = await accounts.createAccount(
      name: 'Bank',
      type: AccountType.bank,
      openingBalance: 0,
    );

    await transactions.addTransaction(
      accountId: cashId,
      amount: 10,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 5),
    );
    await transactions.addTransaction(
      accountId: bankId,
      amount: 20,
      type: TransactionType.expense,
      date: DateTime(2025, 1, 6),
    );

    final query = TransactionsQuery(
      start: DateTime(2025, 1, 1),
      end: DateTime(2025, 1, 31),
      accountId: cashId,
    );

    final sub = container.listen(transactionsProvider(query), (_, __) {});
    addTearDown(sub.close);

    await Future<void>.delayed(Duration.zero);

    final txAsync = container.read(transactionsProvider(query));
    expect(txAsync.hasValue, isTrue);
    expect(txAsync.value!.length, 1);
    expect(txAsync.value!.single.accountId, cashId);
  });
}
