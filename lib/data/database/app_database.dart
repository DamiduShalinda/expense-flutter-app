import 'package:drift/drift.dart';

import 'open_connection.dart';

part 'app_database.g.dart';
part '../tables/accounts.dart';
part '../tables/categories.dart';
part '../tables/preferences.dart';
part '../tables/transfers.dart';
part '../tables/transactions.dart';

enum AccountType { cash, bank, creditCard }

enum TransactionType { income, expense, transfer }

enum AppThemeMode { system, light, dark }

@DriftDatabase(
  tables: [Accounts, Categories, Preferences, Transactions, Transfers],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(preferences);
      }
      if (from == 2) {
        await m.addColumn(preferences, preferences.isDemoMode);
        await m.addColumn(preferences, preferences.hasSeenFirstRunPrompt);
      }
    },
  );

  Future<void> verifyOpens() async {
    await (select(accounts)..limit(1)).get();
  }
}
