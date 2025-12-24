import 'dart:convert';
import 'dart:io';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/accounts_repository.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/data/repositories/transfers_repository.dart';

class CsvImportService {
  const CsvImportService();

  Future<void> importAll({
    required AppDatabase db,
    required Directory sourceDirectory,
    required AccountsRepository accountsRepository,
    required CategoriesRepository categoriesRepository,
    required TransactionsRepository transactionsRepository,
    required TransfersRepository transfersRepository,
  }) async {
    final accountsFile = File('${sourceDirectory.path}/accounts.csv');
    final categoriesFile = File('${sourceDirectory.path}/categories.csv');
    final transactionsFile = File('${sourceDirectory.path}/transactions.csv');
    final transfersFile = File('${sourceDirectory.path}/transfers.csv');

    if (!accountsFile.existsSync() ||
        !categoriesFile.existsSync() ||
        !transactionsFile.existsSync() ||
        !transfersFile.existsSync()) {
      throw StateError(
        'Missing required CSV files in ${sourceDirectory.path}',
      );
    }

    final accountsRows = _readCsv(
      await accountsFile.readAsString(),
      expectedHeader:
          'id,name,type,openingBalance,currentBalance,creditLimit,billingStartDay,dueDay,isArchived',
    );
    final categoriesRows = _readCsv(
      await categoriesFile.readAsString(),
      expectedHeader: 'id,name,parentId,color,icon,isIncome',
    );
    final transactionsRows = _readCsv(
      await transactionsFile.readAsString(),
      expectedHeader: 'id,amount,type,accountId,categoryId,note,date,isPending',
    );
    final transfersRows = _readCsv(
      await transfersFile.readAsString(),
      expectedHeader:
          'id,fromAccountId,toAccountId,amount,date,linkedTransactionIds',
    );

    final accountIds = <int>{};
    final categoryIds = <int>{};
    final transactionIds = <int>{};
    final transactionTypesById = <int, TransactionType>{};

    for (final row in accountsRows) {
      accountIds.add(_requireInt(row['id']!, 'accounts.id'));
    }
    for (final row in categoriesRows) {
      categoryIds.add(_requireInt(row['id']!, 'categories.id'));
    }
    for (final row in transactionsRows) {
      final id = _requireInt(row['id']!, 'transactions.id');
      final type = _parseTransactionType(row['type']!);
      transactionIds.add(id);
      transactionTypesById[id] = type;
    }

    for (final row in categoriesRows) {
      final parentId = _tryParseInt(row['parentId']!);
      if (parentId != null && !categoryIds.contains(parentId)) {
        throw StateError('Unknown parentId $parentId in categories.csv');
      }
    }

    for (final row in transactionsRows) {
      final accountId = _requireInt(row['accountId']!, 'transactions.accountId');
      if (!accountIds.contains(accountId)) {
        throw StateError('Unknown accountId $accountId in transactions.csv');
      }
      final categoryId = _tryParseInt(row['categoryId']!);
      if (categoryId != null && !categoryIds.contains(categoryId)) {
        throw StateError('Unknown categoryId $categoryId in transactions.csv');
      }
    }

    for (final row in transfersRows) {
      final fromId = _requireInt(row['fromAccountId']!, 'transfers.fromAccountId');
      final toId = _requireInt(row['toAccountId']!, 'transfers.toAccountId');
      if (!accountIds.contains(fromId) || !accountIds.contains(toId)) {
        throw StateError('Unknown accountId in transfers.csv');
      }
      final linkedIds = _parseLinkedTransactionIds(row['linkedTransactionIds']!);
      if (linkedIds.length != 2) {
        throw StateError('linkedTransactionIds must contain 2 ids');
      }
      for (final id in linkedIds) {
        if (!transactionIds.contains(id)) {
          throw StateError('Unknown linkedTransactionId $id in transfers.csv');
        }
        if (transactionTypesById[id] != TransactionType.transfer) {
          throw StateError(
            'linkedTransactionIds must reference transfer transactions',
          );
        }
      }
    }

    await db.transaction(() async {
      for (final row in accountsRows) {
        await accountsRepository.importAccount(
          id: _requireInt(row['id']!, 'accounts.id'),
          name: row['name']!,
          type: _parseAccountType(row['type']!),
          openingBalance: _requireInt(
            row['openingBalance']!,
            'accounts.openingBalance',
          ),
          currentBalance: _requireInt(
            row['currentBalance']!,
            'accounts.currentBalance',
          ),
          creditLimit: _tryParseInt(row['creditLimit']!),
          billingStartDay: _tryParseInt(row['billingStartDay']!),
          dueDay: _tryParseInt(row['dueDay']!),
          isArchived: _parseBool(row['isArchived']!, 'accounts.isArchived'),
        );
      }

      for (final row in categoriesRows) {
        await categoriesRepository.importCategory(
          id: _requireInt(row['id']!, 'categories.id'),
          name: row['name']!,
          parentId: _tryParseInt(row['parentId']!),
          color: _requireInt(row['color']!, 'categories.color'),
          icon: _requireInt(row['icon']!, 'categories.icon'),
          isIncome: _parseBool(row['isIncome']!, 'categories.isIncome'),
        );
      }

      for (final row in transactionsRows) {
        final note = row['note']!;
        await transactionsRepository.importTransaction(
          id: _requireInt(row['id']!, 'transactions.id'),
          amount: _requireInt(row['amount']!, 'transactions.amount'),
          type: _parseTransactionType(row['type']!),
          accountId: _requireInt(row['accountId']!, 'transactions.accountId'),
          categoryId: _tryParseInt(row['categoryId']!),
          note: note.trim().isEmpty ? null : note,
          date: _parseDate(row['date']!, 'transactions.date'),
          isPending: _parseBool(row['isPending']!, 'transactions.isPending'),
        );
      }

      for (final row in transfersRows) {
        await transfersRepository.importTransfer(
          id: _requireInt(row['id']!, 'transfers.id'),
          fromAccountId: _requireInt(
            row['fromAccountId']!,
            'transfers.fromAccountId',
          ),
          toAccountId: _requireInt(
            row['toAccountId']!,
            'transfers.toAccountId',
          ),
          amount: _requireInt(row['amount']!, 'transfers.amount'),
          date: _parseDate(row['date']!, 'transfers.date'),
          linkedTransactionIds: row['linkedTransactionIds']!,
        );
      }

      for (final accountId in accountIds) {
        await accountsRepository.recalculateAndPersistCurrentBalance(accountId);
      }
    });
  }
}

List<Map<String, String>> _readCsv(
  String content, {
  required String expectedHeader,
}) {
  final lines = const LineSplitter().convert(content.trimRight());
  if (lines.isEmpty) {
    throw const FormatException('CSV is empty');
  }

  final header = _parseCsvLine(lines.first);
  final expected = expectedHeader.split(',');
  if (header.length != expected.length) {
    throw FormatException('Invalid CSV header: ${lines.first}');
  }
  for (var i = 0; i < expected.length; i++) {
    if (header[i] != expected[i]) {
      throw FormatException('Invalid CSV header: ${lines.first}');
    }
  }

  final rows = <Map<String, String>>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final values = _parseCsvLine(line);
    if (values.length != expected.length) {
      throw FormatException('Invalid CSV row: $line');
    }
    final row = <String, String>{};
    for (var i = 0; i < expected.length; i++) {
      row[expected[i]] = values[i];
    }
    rows.add(row);
  }
  return rows;
}

List<String> _parseCsvLine(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (inQuotes) {
      if (char == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        buffer.write(char);
      }
    } else {
      if (char == ',') {
        values.add(buffer.toString());
        buffer.clear();
      } else if (char == '"') {
        inQuotes = true;
      } else {
        buffer.write(char);
      }
    }
  }

  values.add(buffer.toString());
  return values;
}

int _requireInt(String value, String field) {
  final parsed = int.tryParse(value);
  if (parsed == null) {
    throw FormatException('Invalid int for $field: $value');
  }
  return parsed;
}

int? _tryParseInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final parsed = int.tryParse(trimmed);
  if (parsed == null) {
    throw FormatException('Invalid int: $value');
  }
  return parsed;
}

bool _parseBool(String value, String field) {
  if (value == '1') return true;
  if (value == '0') return false;
  throw FormatException('Invalid bool for $field: $value');
}

AccountType _parseAccountType(String value) {
  try {
    return AccountType.values.byName(value);
  } catch (_) {
    throw FormatException('Invalid account type: $value');
  }
}

TransactionType _parseTransactionType(String value) {
  try {
    return TransactionType.values.byName(value);
  } catch (_) {
    throw FormatException('Invalid transaction type: $value');
  }
}

DateTime _parseDate(String value, String field) {
  try {
    return DateTime.parse(value);
  } catch (_) {
    throw FormatException('Invalid date for $field: $value');
  }
}

List<int> _parseLinkedTransactionIds(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException('linkedTransactionIds must be a list');
    }
    return decoded.map((value) {
      if (value is! int) {
        throw const FormatException('linkedTransactionIds must contain ints');
      }
      return value;
    }).toList();
  } catch (_) {
    throw FormatException('Invalid linkedTransactionIds: $raw');
  }
}
