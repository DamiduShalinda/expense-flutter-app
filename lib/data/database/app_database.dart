import 'package:drift/drift.dart';

import 'open_connection.dart';

part 'app_database.g.dart';
part '../tables/accounts.dart';
part '../tables/categories.dart';
part '../tables/transfers.dart';
part '../tables/transactions.dart';

enum AccountType { cash, bank, creditCard }

enum TransactionType { income, expense, transfer }

@DriftDatabase(tables: [Accounts, Categories, Transactions, Transfers])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> verifyOpens() async {
    await (select(accounts)..limit(1)).get();
  }
}

