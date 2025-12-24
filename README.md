# Expense Manage

Offline-first local expense tracking app built with Flutter + Drift (SQLite) + Riverpod.

## Setup

- Run `flutter pub get`
- Generate Drift code: `flutter pub run build_runner build --delete-conflicting-outputs`

## Default Data

- The app ensures these default accounts exist when needed:
  - `Savings` (type: `bank`)
  - `Credit Card` (type: `creditCard`)
- Categories default to `Uncategorized` (expense + income) when needed.

## Demo Mode

Demo mode helps you try the app quickly with realistic sample data.

- First run: the app prompts you to start with demo data.
- Settings: toggle demo mode in `Settings → Demo mode`.
- Exiting demo mode wipes everything (accounts, categories, transactions, transfers) and re-creates the default `Savings` + `Credit Card` accounts.

## Seed Demo Data (Dev)

You can seed the same demo dataset via the tool script:

- `flutter run -t tool/seed_mock_data.dart`

This uses the same seeding logic as the in-app demo mode.
