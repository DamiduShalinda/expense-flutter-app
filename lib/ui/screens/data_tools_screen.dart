import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:expense_manage/domain/services/csv_export_service.dart';
import 'package:expense_manage/domain/services/csv_import_service.dart';
import 'package:expense_manage/providers/database_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

class DataToolsScreen extends ConsumerStatefulWidget {
  const DataToolsScreen({super.key});

  @override
  ConsumerState<DataToolsScreen> createState() => _DataToolsScreenState();
}

class _DataToolsScreenState extends ConsumerState<DataToolsScreen> {
  bool _exporting = false;
  bool _importing = false;
  String? _lastExportPath;
  String? _lastImportPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data tools')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export CSV'),
            subtitle: const Text('Exports CSV files and opens share options'),
            trailing: _exporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _exporting ? null : () => _export(context),
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Import CSV'),
            subtitle: const Text(
              'Imports accounts.csv, categories.csv, transactions.csv, transfers.csv',
            ),
            trailing: _importing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _importing ? null : () => _promptImport(context),
          ),
          _buildSampleCard(context),
          if (_lastExportPath != null)
            ListTile(
              title: const Text('Last export'),
              subtitle: Text(_lastExportPath!),
            ),
          if (_lastImportPath != null)
            ListTile(
              title: const Text('Last import'),
              subtitle: Text(_lastImportPath!),
            ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    setState(() => _exporting = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final db = ref.read(appDatabaseProvider);
      const exporter = CsvExportService();
      final result = await exporter.exportAll(db: db, outputDirectory: dir);

      if (!mounted) return;
      setState(() => _lastExportPath = result.folderPath);
      final folder = Directory(result.folderPath);
      final files = [
        XFile('${folder.path}/accounts.csv', mimeType: 'text/csv'),
        XFile('${folder.path}/categories.csv', mimeType: 'text/csv'),
        XFile('${folder.path}/transactions.csv', mimeType: 'text/csv'),
        XFile('${folder.path}/transfers.csv', mimeType: 'text/csv'),
      ];
      await Share.shareXFiles(files, subject: 'Expense export');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _promptImport(BuildContext context) async {
    final controller = TextEditingController(text: _lastExportPath ?? '');
    final path = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import CSV'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Folder path',
              hintText: '/path/to/expense_export_123',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (path == null || path.isEmpty) return;
    await _import(context, path);
  }

  Future<void> _import(BuildContext context, String path) async {
    setState(() => _importing = true);
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        throw StateError('Folder not found: $path');
      }

      const importer = CsvImportService();
      await importer.importAll(
        db: ref.read(appDatabaseProvider),
        sourceDirectory: dir,
        accountsRepository: ref.read(accountsRepositoryProvider),
        categoriesRepository: ref.read(categoriesRepositoryProvider),
        transactionsRepository: ref.read(transactionsRepositoryProvider),
        transfersRepository: ref.read(transfersRepositoryProvider),
      );

      if (!mounted) return;
      setState(() => _lastImportPath = path);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Import complete')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Widget _buildSampleCard(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ExpansionTile(
        title: const Text('Sample import CSV'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Text('accounts.csv'),
          SelectableText(_sampleAccountsCsv, style: textStyle),
          const SizedBox(height: 12),
          const Text('categories.csv'),
          SelectableText(_sampleCategoriesCsv, style: textStyle),
          const SizedBox(height: 12),
          const Text('transactions.csv'),
          SelectableText(_sampleTransactionsCsv, style: textStyle),
          const SizedBox(height: 12),
          const Text('transfers.csv'),
          SelectableText(_sampleTransfersCsv, style: textStyle),
        ],
      ),
    );
  }
}

const _sampleAccountsCsv = '''
id,name,type,openingBalance,currentBalance,creditLimit,billingStartDay,dueDay,isArchived
1,"Cash",cash,10000,8000,,,,0
2,"Card",creditCard,0,1200,5000,1,25,0
''';

const _sampleCategoriesCsv = '''
id,name,parentId,color,icon,isIncome
1,"Food",,4294901760,59392,0
2,"Salary",,4278232575,58750,1
''';

const _sampleTransactionsCsv = '''
id,amount,type,accountId,categoryId,note,date,isPending
10,2000,expense,1,1,"Lunch",2024-08-01T12:00:00.000,0
11,5000,income,1,2,"August salary",2024-08-01T09:00:00.000,0
12,300,transfer,1,,,2024-08-02T08:00:00.000,0
13,300,transfer,2,,,2024-08-02T08:00:00.000,0
''';

const _sampleTransfersCsv = '''
id,fromAccountId,toAccountId,amount,date,linkedTransactionIds
5,1,2,300,2024-08-02T08:00:00.000,"[12,13]"
''';
