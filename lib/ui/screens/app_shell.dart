import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/demo_mode_provider.dart';
import 'package:expense_manage/providers/preferences_provider.dart';
import 'accounts_screen.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'transactions_screen.dart';
import 'transaction_sheet.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;
  bool _promptShown = false;
  ProviderSubscription<AsyncValue<Preference>>? _prefSubscription;

  @override
  void initState() {
    super.initState();
    _prefSubscription = ref.listenManual(preferencesProvider, (prev, next) {
      next.whenData((pref) {
        if (_promptShown) return;
        if (pref.hasSeenFirstRunPrompt) return;
        _promptShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showFirstRunPrompt();
        });
      });
    });
  }

  @override
  void dispose() {
    _prefSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Transactions',
      ),
      const NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: Icon(Icons.account_balance_wallet),
        label: 'Accounts',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    final screens = <Widget>[
      const DashboardScreen(),
      const TransactionsScreen(),
      const AccountsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(destinations[_index].label)),
      body: IndexedStack(index: _index, children: screens),
      floatingActionButton:
          _index == 0
              ? FloatingActionButton(
                onPressed: () => showAddTransactionSheet(context),
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: destinations,
        onDestinationSelected: (value) => setState(() => _index = value),
      ),
    );
  }

  Future<void> _showFirstRunPrompt() async {
    final choice = await showDialog<_FirstRunChoice>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Get started'),
          content: const Text(
            'Start with demo data to explore the app faster?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, _FirstRunChoice.continueEmpty),
              child: const Text('No thanks'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, _FirstRunChoice.demo),
              child: const Text('Use demo data'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (choice == null) return;

    final service = ref.read(demoModeServiceProvider);
    try {
      if (choice == _FirstRunChoice.demo) {
        await service.enterDemoMode();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo mode enabled')),
        );
      } else {
        await service.initializeStandardDefaults();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Setup failed: $e')),
      );
    }
  }
}

enum _FirstRunChoice { demo, continueEmpty }
