
# Project Guidelines - Local Expense Tracking App

## Platform:
- Flutter

## Storage:
- Drift (SQLite)

## State management:
- Riverpod

## UI:
- Minimal, Material 3

## Offline-first

## Global Rules (VERY IMPORTANT)
- Implement ONLY the requested task
- Do NOT refactor unrelated files
- Do NOT invent features not listed in the task
- Prefer clarity over cleverness
- Keep code simple, readable, and explicit
- No breaking changes without instruction

## Architecture Rules
### Folder Structure
```
lib/
├── data/
│    ├── database/
│    ├── tables/
│    └── repositories/
├── domain/
│    ├── models/
│    └── services/
├── providers/
├── ui/
│    ├── screens/
│    ├── widgets/
│    └── theme/
└── main.dart
```

### Folder Rules
- Database logic → data/
- Business rules → domain/
- UI → ui/
- State → providers/

### Database Rules (Drift)
- Use Drift ORM only
- No raw SQL unless explicitly asked
- Every table must:
  - Have an id (auto increment)
  - Be immutable after creation
  - All writes go through repository classes
  - Transfers must use transactions

### Account Logic Rules
- Account types:
  - cash
  - bank
  - creditCard
- Credit cards:
  - Balance increases = debt
  - Respect credit limit
- Never delete accounts with transactions
- Support archive instead of delete

### Transaction Rules
- Types:
  - income
  - expense
  - transfer
- Expenses reduce balance
- Income increases balance
- Pending transactions:
  - Do NOT affect totals
- Transfers:
  - Always create two linked transactions
  - Must be atomic

### Category Rules
- Categories can have:
  - Parent
  - Subcategories
- Categories must have:
  - Color
  - Icon
- Category deletion:
  - If used → reassign to “Uncategorized”

### State Management Rules (Riverpod)
- Use Notifier / AsyncNotifier
- Providers must be:
  - Pure
  - Testable
  - No UI logic inside providers
- DB access only via repositories

### UI Rules
- Minimal design
- No heavy animations
- Respect platform defaults
- Reusable widgets preferred
- Bottom sheets for:
  - Add transaction
  - Select category
  - Select account

### Dashboard Rules
- Calculations must be:
  - Date-range based
  - Exclude pending transactions
  - Week start depends on user settings
- Totals must match transaction list

### Settings Rules
- Preferences stored locally
- No cloud sync unless requested
- Export format:
  - CSV
- Import must validate schema

### Error Handling
- Fail gracefully
- Never crash on:
  - Empty DB
  - Missing category
  - Archived account
- Show user-friendly messages

### Testing Mindset (Even if no tests)
- Code must be:
  - Deterministic
  - Side-effect aware
  - Avoid static singletons
  - Prefer dependency injection

### Commit Discipline
- Each task should result in:
  - Clear changes
  - Predictable behavior
  - No TODO left behind

### Codex Execution Pattern
When given a task:
- Read task ID (example: T1.2)
- Locate relevant layer (DB / domain / UI)
- Implement only that
- Output:
  - Files changed
  - Brief explanation
  - Stop

### Forbidden Actions ❌
- Adding new dependencies
- Changing app navigation
- Redesigning UI
- Renaming existing models
- Optimizing prematurely

### Default Assumptions
- Single user
- Single currency
- Offline only
- No authentication

### Success Criteria
- App compiles
- Feature works as described
- No regression
- Code is readable by humans
