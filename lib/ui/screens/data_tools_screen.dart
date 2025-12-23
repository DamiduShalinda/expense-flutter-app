import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:expense_manage/domain/services/csv_export_service.dart';
import 'package:expense_manage/providers/database_provider.dart';

class DataToolsScreen extends ConsumerStatefulWidget {
  const DataToolsScreen({super.key});

  @override
  ConsumerState<DataToolsScreen> createState() => _DataToolsScreenState();
}

class _DataToolsScreenState extends ConsumerState<DataToolsScreen> {
  bool _exporting = false;
  String? _lastExportPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data tools')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export CSV'),
            subtitle: const Text('Writes CSV files to app documents folder'),
            trailing: _exporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _exporting ? null : () => _export(context),
          ),
          if (_lastExportPath != null)
            ListTile(
              title: const Text('Last export'),
              subtitle: Text(_lastExportPath!),
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
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export complete'),
          content: SelectableText(result.folderPath),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
