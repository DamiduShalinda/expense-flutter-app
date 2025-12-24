import 'dart:math';

import 'package:expense_manage/data/database/app_database.dart';

class LoanCalculationResult {
  const LoanCalculationResult({
    required this.totalPayable,
    required this.monthlyInstallment,
  });

  final double totalPayable;
  final double monthlyInstallment;
}

class LoanCalculator {
  const LoanCalculator();

  LoanCalculationResult calculate({
    required int principalAmount,
    required double interestRate,
    required LoanInterestType interestType,
    required int durationMonths,
  }) {
    if (principalAmount <= 0) {
      throw ArgumentError.value(
        principalAmount,
        'principalAmount',
        'Must be > 0',
      );
    }
    if (interestRate < 0) {
      throw ArgumentError.value(interestRate, 'interestRate', 'Must be >= 0');
    }
    if (durationMonths <= 0) {
      throw ArgumentError.value(
        durationMonths,
        'durationMonths',
        'Must be > 0',
      );
    }

    if (interestType == LoanInterestType.fixed || interestRate == 0) {
      final totalInterest =
          principalAmount * (interestRate / 100) * (durationMonths / 12);
      final totalPayable = principalAmount + totalInterest;
      final monthlyInstallment = totalPayable / durationMonths;
      return LoanCalculationResult(
        totalPayable: totalPayable,
        monthlyInstallment: monthlyInstallment,
      );
    }

    final monthlyRate = interestRate / 100 / 12;
    final factor = pow(1 + monthlyRate, durationMonths);
    final monthlyInstallment =
        principalAmount * monthlyRate * factor / (factor - 1);
    final totalPayable = monthlyInstallment * durationMonths;
    return LoanCalculationResult(
      totalPayable: totalPayable,
      monthlyInstallment: monthlyInstallment,
    );
  }
}
