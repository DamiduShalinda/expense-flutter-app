import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/demo_mode_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'package:expense_manage/ui/screens/data_tools_screen.dart';
import 'categories_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefAsync = ref.watch(preferencesProvider);

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Preferences'),
        ),
        prefAsync.when(
          data: (pref) => Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.science_outlined),
                title: const Text('Demo mode'),
                subtitle: const Text('Seeds demo data; exiting wipes everything'),
                value: pref.isDemoMode,
                onChanged: (value) => _toggleDemoMode(context, ref, value),
              ),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Currency'),
                trailing: DropdownButton<String>(
                  value: pref.currencyCode,
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                    DropdownMenuItem(value: 'LKR', child: Text('LKR')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(preferencesProvider.notifier)
                        .setCurrencyCode(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('First day of week'),
                trailing: DropdownButton<int>(
                  value: pref.firstDayOfWeek,
                  items: const [
                    DropdownMenuItem(
                      value: DateTime.monday,
                      child: Text('Mon'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.tuesday,
                      child: Text('Tue'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.wednesday,
                      child: Text('Wed'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.thursday,
                      child: Text('Thu'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.friday,
                      child: Text('Fri'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.saturday,
                      child: Text('Sat'),
                    ),
                    DropdownMenuItem(
                      value: DateTime.sunday,
                      child: Text('Sun'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(preferencesProvider.notifier)
                        .setFirstDayOfWeek(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6_outlined),
                title: const Text('Theme'),
                trailing: DropdownButton<AppThemeMode>(
                  value: pref.themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: AppThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    ref.read(preferencesProvider.notifier).setThemeMode(value);
                  },
                ),
              ),
            ],
          ),
          error: (error, _) => ListTile(
            leading: const Icon(Icons.error_outline),
            title: const Text('Failed to load preferences'),
            subtitle: Text('$error'),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Data'),
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: const Text('Data tools'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DataToolsScreen()),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Settings'),
        ),
        ListTile(
          leading: const Icon(Icons.category_outlined),
          title: const Text('Categories'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleDemoMode(
    BuildContext context,
    WidgetRef ref,
    bool nextValue,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nextValue ? 'Enable demo mode?' : 'Exit demo mode?'),
          content: const Text('This will wipe all data on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final service = ref.read(demoModeServiceProvider);
    try {
      if (nextValue) {
        await service.enterDemoMode();
      } else {
        await service.exitDemoMode();
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nextValue ? 'Demo mode enabled' : 'Demo mode disabled'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }
}
