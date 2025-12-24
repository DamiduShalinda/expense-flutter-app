Implementation Plan: “Pay on behalf / Receivable handling”
Goal

Support:

Paying for someone else

Tracking money owed to you

Settling later

Keeping expenses & reports accurate

Without introducing new transaction types or breaking dashboards.

Phase 1 — Data model (minimal, safe)
T1 — Add a logical receivable account

Decision:
👉 Do NOT add a new account type yet
Reuse existing cash/bank type with a flag.

Accounts table change (minimal)

Add:

isVirtual BOOLEAN DEFAULT FALSE


Usage:

Owed to Me → isVirtual = true

Normal accounts → false

Why?

No balance validation issues

No UI confusion with real money

No need to touch transaction logic

✅ Backward compatible
✅ No breaking change

T2 — Seed default “Owed to Me” account

Where:

App bootstrap OR first transaction creation

Rules:

If no account exists with isVirtual = true

Create:

name: Owed to Me

type: cash

openingBalance: 0

isVirtual: true

⚠️ Never auto-delete this account.

Phase 2 — Domain logic (core behavior)
T3 — Define the flow (no new transaction types)

You will use existing primitives only:

Action	What happens
Pay full bill	Expense + Transfer
Someone pays back	Transfer
Partial payback	Transfer (partial amount)
T4 — Split-bill domain service

Create a domain service, not UI logic.

lib/domain/services/split_payment_service.dart


Responsibility:

Validate amounts

Create correct transactions

Wrap everything in a DB transaction

Input model
class SplitPaymentInput {
  final int paidFromAccountId;
  final int categoryId;
  final double totalAmount;
  final double myShare;
  final DateTime date;
  final String? note;
}

Rules enforced

myShare <= totalAmount

myShare >= 0

totalAmount > 0

Receivable = totalAmount - myShare

T5 — Atomic write logic (important)

Inside repository transaction:

1️⃣ Create expense transaction

Expense
Amount = myShare
Account = paidFromAccount
Category = selected category


2️⃣ If receivable > 0, create transfer

From = paidFromAccount
To = Owed to Me
Amount = receivable


3️⃣ Commit

If anything fails → rollback.

This keeps balances and reports correct.

Phase 3 — Settlement logic
T6 — Settle receivable (payback)

No new logic needed.

Use existing transfer flow:

From: Owed to Me
To: Cash / Bank
Amount: X


Optional validation:

Prevent transfer if Owed to Me.balance < amount

Phase 4 — UI changes (small, focused)
T7 — Transaction add screen (minimal UX)

Add optional toggle:

[ ] Paid on behalf of someone


When enabled:

Show:

“My share” input

Auto-calc:

“Owed amount” = total − my share

Show preview:

Expense amount

Receivable amount

⚠️ Do NOT expose “Owed to Me” directly in the selector.

T8 — Accounts screen handling

Show Owed to Me under a section:

Virtual / Tracking Accounts


Use different icon / muted color

Exclude from:

“Cash on hand” summary

Include in:

Net worth (optional, future)

Phase 5 — Analytics & dashboard safety
T9 — Dashboard rules (important)

Ensure:

Expense totals include only expense transactions

Transfers never affect expense/income totals

Pending logic unchanged

No changes required if your rules are followed correctly.

Phase 6 — Optional (future-ready, but skip now)

❌ Do NOT implement yet — just plan for it.

Later extensions:

counterpartyName in transfer

Due dates

Reminder notifications

Per-person virtual accounts

Auto settlement suggestions

Your current design will support all of these.