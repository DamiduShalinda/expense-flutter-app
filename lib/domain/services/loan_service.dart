import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/data/repositories/categories_repository.dart';
import 'package:expense_manage/data/repositories/loan_repository.dart';
import 'package:expense_manage/data/repositories/transactions_repository.dart';
import 'package:expense_manage/domain/services/loan_calculator.dart';
import 'package:expense_manage/domain/services/loan_schedule_generator.dart';

class LoanService {
  LoanService({
    required LoanRepository loanRepository,
    required TransactionsRepository transactionsRepository,
    required CategoriesRepository categoriesRepository,
    LoanCalculator? calculator,
    LoanScheduleGenerator? scheduleGenerator,
  }) : _loans = loanRepository,
       _transactions = transactionsRepository,
       _categories = categoriesRepository,
       _calculator = calculator ?? const LoanCalculator(),
       _scheduleGenerator = scheduleGenerator ?? const LoanScheduleGenerator();

  final LoanRepository _loans;
  final TransactionsRepository _transactions;
  final CategoriesRepository _categories;
  final LoanCalculator _calculator;
  final LoanScheduleGenerator _scheduleGenerator;

  Future<int> createLoan({
    required String name,
    required int accountId,
    required int principalAmount,
    required double interestRate,
    required LoanInterestType interestType,
    required int durationMonths,
    required int paymentDay,
    DateTime? startDate,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    }

    final calculation = _calculator.calculate(
      principalAmount: principalAmount,
      interestRate: interestRate,
      interestType: interestType,
      durationMonths: durationMonths,
    );

    final loanStart = startDate ?? DateTime.now();
    final schedule = _scheduleGenerator.generate(
      principalAmount: principalAmount,
      interestRate: interestRate,
      interestType: interestType,
      durationMonths: durationMonths,
      paymentDay: paymentDay,
      startDate: loanStart,
    );

    final totalPayableAmount = schedule.fold<int>(
      0,
      (sum, item) =>
          sum + item.principalDue.round() + item.interestDue.round(),
    );
    final monthlyInstallment = calculation.monthlyInstallment.round();

    final defaults = await _categories.ensureDefaultCategories();
    final disbursementTransactionId = await _transactions.addTransaction(
      accountId: accountId,
      amount: principalAmount,
      type: TransactionType.income,
      categoryId: defaults.incomeId,
      note: 'Loan disbursement: $trimmed',
      date: loanStart,
    );

    return _loans.createLoan(
      name: trimmed,
      accountId: accountId,
      disbursementTransactionId: disbursementTransactionId,
      principalAmount: principalAmount,
      interestRate: interestRate,
      interestType: interestType,
      durationMonths: durationMonths,
      paymentDay: paymentDay,
      totalPayableAmount: totalPayableAmount,
      monthlyInstallment: monthlyInstallment,
      outstandingAmount: totalPayableAmount,
      schedule: schedule,
    );
  }
}
