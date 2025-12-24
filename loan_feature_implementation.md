📌 Loan Feature — Task Plan

Scope: Offline-first, single-user, Drift + Riverpod
Goal: Deterministic loan contracts with fixed & compound interest

PHASE L1 — Database Layer (Drift)
T L1.1 — Extend Loans table

Location: lib/data/tables/loans.dart

Add fields:

principalAmount

interestRate

interestType (fixed, compound)

durationMonths

paymentDay

totalPayableAmount

monthlyInstallment

outstandingAmount

isClosed

Rules:

Values are immutable after creation (except outstandingAmount, isClosed)

No business logic in table files

T L1.2 — Add LoanInstallments table

Location: lib/data/tables/loan_installments.dart

Fields:

loanId (FK)

installmentNumber

dueDate

principalDue

interestDue

totalDue

isPaid

Rules:

One row per month

Generated only once (on loan creation)

T L1.3 — Add LoanPayments table

Location: lib/data/tables/loan_payments.dart

Fields:

loanId

transactionId

amount

principalPart

interestPart

date

Rules:

Every loan payment MUST reference a transaction

Never write directly to balances

PHASE L2 — Domain Logic
T L2.1 — LoanCalculator service

Location: lib/domain/services/loan_calculator.dart

Responsibilities:

Calculate:

total payable

monthly installment

Support:

fixed interest

compound interest (EMI)

Constraints:

Pure functions only

No DB access

Deterministic output

T L2.2 — LoanScheduleGenerator

Location: lib/domain/services/loan_schedule_generator.dart

Responsibilities:

Generate installment schedule

Split principal vs interest

Generate safe due dates (day ≤ 28)

Algorithm:

O(n) where n = durationMonths

No rounding until persistence

T L2.3 — LoanService

Location: lib/domain/services/loan_service.dart

Responsibilities:

Create loan

Persist loan + installments atomically

Initialize outstandingAmount

Close loan automatically when settled

PHASE L3 — Repository Layer
T L3.1 — LoanRepository

Location: lib/data/repositories/loan_repository.dart

Expose:

createLoan()

getActiveLoans()

getLoanById()

updateOutstanding()

closeLoan()

Rules:

All writes inside Drift transactions

No calculations here

T L3.2 — LoanPaymentRepository

Location: lib/data/repositories/loan_payment_repository.dart

Expose:

recordPayment()

getPaymentsForLoan()

Atomic flow:

Create transaction

Insert loan payment

Update installment

Update loan outstanding

PHASE L4 — State Management (Riverpod)
T L4.1 — LoansProvider

Location: lib/providers/loans_provider.dart

Expose:

Active loans

Closed loans

T L4.2 — LoanDetailsProvider

Param: loanId

Expose:

Loan info

Installments

Payments

PHASE L5 — Transaction Integration
T L5.1 — Loan disbursement

Generate income/expense transaction

Link to loan

T L5.2 — Loan installment payment

Validate installment

Prevent overpayment

Respect pending transactions rule

PHASE L6 — UI (Minimal, No Redesign)
T L6.1 — Add Loan screen

Fields:

Loan name

Amount

Interest rate

Interest type

Duration

Payment day

Linked account

T L6.2 — Loan details screen

Show:

Outstanding amount

Installment list

Paid vs unpaid

T L6.3 — Pay installment flow

Bottom sheet

Select installment

Confirm payment

PHASE L7 — Dashboard & Analytics
T L7.1 — Net worth update

Subtract payable loans

Add receivable loans

T L7.2 — Category correctness

Ensure loan interest is categorized correctly

Exclude pending payments

PHASE L8 — Validation & Safety
T L8.1 — Edge cases

Payment date overflow

Floating-point rounding

Partial payments

Archived account handling

T L8.2 — Data integrity

Loan cannot be deleted

Installments immutable

Payments always traceable