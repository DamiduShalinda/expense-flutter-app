
# Project Plan

## PHASE 0 — Project setup

### T0.1 – Flutter project setup
- Create Flutter app
- Enable Material 3
- Minimal theme (light + dark)

### T0.2 – Dependencies
- Add:
  - drift
  - drift_flutter
  - path_provider
  - sqlite3_flutter_libs
  - flutter_riverpod
- Configure code generation

### T0.3 – App structure
- Create folders:
  - data/
  - domain/
  - ui/
  - providers/

## PHASE 1 — Database (Drift)

### T1.1 – Database bootstrap
- Create AppDatabase
- Configure lazy database
- Verify DB opens correctly

### T1.2 – Accounts table
- Fields:
  - id
  - name
  - type (cash/bank/credit)
  - openingBalance
  - currentBalance
  - creditLimit (nullable)
  - billingStartDay (nullable)
  - dueDay (nullable)
  - isArchived

### T1.3 – Categories table
- Fields:
  - id
  - name
  - parentId (nullable)
  - color
  - icon
  - isIncome

### T1.4 – Transactions table
- Fields:
  - id
  - amount
  - type (income/expense/transfer)
  - accountId
  - categoryId (nullable)
  - note
  - date
  - isPending

### T1.5 – Transfers table
- Fields:
  - id
  - fromAccountId
  - toAccountId
  - amount
  - date
  - linkedTransactionIds

## PHASE 2 — Domain logic

### T2.1 – Account balance logic
- Calculate current balance
- Apply opening balance
- Update on transaction insert/delete

### T2.2 – Transaction insert logic
- Income → add to account
- Expense → subtract from account
- Pending → exclude from totals

### T2.3 – Transfer logic (double entry)
- Create two transactions:
  - debit source
  - credit destination
- Keep transfer atomic

## PHASE 3 — State management

### T3.1 – Database provider
- Riverpod provider for AppDatabase

### T3.2 – Accounts provider
- Watch all active accounts
- Expose total balance

### T3.3 – Categories provider
- Watch parent + subcategories
- Group by parentId

### T3.4 – Transactions provider
- Watch by date range
- Filter by account / category

## PHASE 4 — UI foundation

### T4.1 – App shell
- Bottom navigation:
  - Dashboard
  - Transactions
  - Accounts
  - Settings

### T4.2 – Shared UI components
- Amount text widget
- Account selector dropdown
- Category selector bottom sheet

## PHASE 5 — Accounts screen

### T5.1 – Accounts list
- Show:
  - name
  - balance
  - type icon

### T5.2 – Add / edit account
- Form:
  - name
  - type
  - opening balance
  - credit card fields (conditional)

### T5.3 – Archive account
- Hide archived accounts
- Prevent deletion if transactions exist

## PHASE 6 — Categories screen (settings)

### T6.1 – Category list
- Parent → expandable subcategories
- Color + icon preview

### T6.2 – Add / edit category
- Select parent
- Pick color
- Pick icon
- Mark as income/expense

## PHASE 7 — Transactions screen

### T7.1 – Transactions list
- Group by date
- Color-coded amounts

### T7.2 – Add transaction
- Select:
  - type
  - account
  - category
  - amount
  - date
- Validate balance for expenses

### T7.3 – Add transfer
- Select:
  - from account
  - to account
  - amount
  - date

## PHASE 8 — Dashboard

### T8.1 – Weekly summary
- This week:
  - total expense
  - total income
  - net

### T8.2 – Category breakdown
- Top 5 categories
- Percentage spend

### T8.3 – Account snapshot
- All account balances
- Credit card utilization

## PHASE 9 — Settings

### T9.1 – App preferences
- Currency
- First day of week
- Theme mode

### T9.2 – Data tools
- Export CSV
- Import CSV
- Reset database

### T9.3 – Demo mode
- First-run prompt to enable demo mode
- Settings toggle to enable/exit
- Exit wipes DB and restores defaults
- Seed script in `tool/seed_mock_data.dart`

## PHASE 10 — Polish & safety

### T10.1 – Validation & edge cases
- No negative transfers
- Same account transfer blocked
- Deleted category handling

### T10.2 – UX polish
- Empty states
- Loading states
- Subtle animations
