import 'dart:io';

import 'package:expense_manage/data/database/app_database.dart';

class CsvExportResult {
  const CsvExportResult({required this.folderPath});

  final String folderPath;
}

class CsvExportService {
  const CsvExportService();

  Future<CsvExportResult> exportAll({
    required AppDatabase db,
    required Directory outputDirectory,
  }) async {
    final folder = Directory(
      '${outputDirectory.path}/expense_export_${DateTime.now().millisecondsSinceEpoch}',
    );
    await folder.create(recursive: true);

    await _writeAccounts(db, folder);
    await _writeCategories(db, folder);
    await _writeTransactions(db, folder);
    await _writeTransfers(db, folder);

    return CsvExportResult(folderPath: folder.path);
  }

  Future<void> _writeAccounts(AppDatabase db, Directory folder) async {
    final rows = await db.select(db.accounts).get();
    final buffer = StringBuffer()
      ..writeln(
        'id,name,type,openingBalance,currentBalance,creditLimit,billingStartDay,dueDay,isArchived',
      );
    for (final a in rows) {
      buffer.writeln(
        [
          a.id,
          _csv(a.name),
          a.type.name,
          a.openingBalance,
          a.currentBalance,
          a.creditLimit ?? '',
          a.billingStartDay ?? '',
          a.dueDay ?? '',
          a.isArchived ? '1' : '0',
        ].join(','),
      );
    }
    await File('${folder.path}/accounts.csv').writeAsString(buffer.toString());
  }

  Future<void> _writeCategories(AppDatabase db, Directory folder) async {
    final rows = await db.select(db.categories).get();
    final buffer = StringBuffer()
      ..writeln('id,name,parentId,color,icon,isIncome');
    for (final c in rows) {
      buffer.writeln(
        [
          c.id,
          _csv(c.name),
          c.parentId ?? '',
          c.color,
          c.icon,
          c.isIncome ? '1' : '0',
        ].join(','),
      );
    }
    await File(
      '${folder.path}/categories.csv',
    ).writeAsString(buffer.toString());
  }

  Future<void> _writeTransactions(AppDatabase db, Directory folder) async {
    final rows = await db.select(db.transactions).get();
    final buffer = StringBuffer()
      ..writeln('id,amount,type,accountId,categoryId,note,date,isPending');
    for (final t in rows) {
      buffer.writeln(
        [
          t.id,
          t.amount,
          t.type.name,
          t.accountId,
          t.categoryId ?? '',
          t.note == null ? '' : _csv(t.note!),
          t.date.toIso8601String(),
          t.isPending ? '1' : '0',
        ].join(','),
      );
    }
    await File(
      '${folder.path}/transactions.csv',
    ).writeAsString(buffer.toString());
  }

  Future<void> _writeTransfers(AppDatabase db, Directory folder) async {
    final rows = await db.select(db.transfers).get();
    final buffer = StringBuffer()
      ..writeln(
        'id,fromAccountId,toAccountId,amount,date,linkedTransactionIds',
      );
    for (final t in rows) {
      buffer.writeln(
        [
          t.id,
          t.fromAccountId,
          t.toAccountId,
          t.amount,
          t.date.toIso8601String(),
          _csv(t.linkedTransactionIds),
        ].join(','),
      );
    }
    await File('${folder.path}/transfers.csv').writeAsString(buffer.toString());
  }
}

String _csv(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}
