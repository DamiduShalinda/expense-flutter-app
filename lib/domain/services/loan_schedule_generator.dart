import 'dart:math';

import 'package:expense_manage/data/database/app_database.dart';

class LoanInstallmentDraft {
  const LoanInstallmentDraft({
    required this.installmentNumber,
    required this.dueDate,
    required this.principalDue,
    required this.interestDue,
    required this.totalDue,
  });

  final int installmentNumber;
  final DateTime dueDate;
  final double principalDue;
  final double interestDue;
  final double totalDue;
}

class LoanScheduleGenerator {
  const LoanScheduleGenerator();

  List<LoanInstallmentDraft> generate({
    required int principalAmount,
    required double interestRate,
    required LoanInterestType interestType,
    required int durationMonths,
    required int paymentDay,
    required DateTime startDate,
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

    final safeDay = paymentDay.clamp(1, 28);
    var firstDue = DateTime(startDate.year, startDate.month, safeDay);
    if (!firstDue.isAfter(startDate)) {
      firstDue = _addMonths(firstDue, 1);
    }

    if (interestType == LoanInterestType.fixed || interestRate == 0) {
      return _fixedSchedule(
        principalAmount: principalAmount,
        interestRate: interestRate,
        durationMonths: durationMonths,
        firstDue: firstDue,
      );
    }

    return _compoundSchedule(
      principalAmount: principalAmount,
      interestRate: interestRate,
      durationMonths: durationMonths,
      firstDue: firstDue,
    );
  }

  List<LoanInstallmentDraft> _fixedSchedule({
    required int principalAmount,
    required double interestRate,
    required int durationMonths,
    required DateTime firstDue,
  }) {
    final totalInterest =
        principalAmount * (interestRate / 100) * (durationMonths / 12);
    final monthlyPrincipal = principalAmount / durationMonths;
    final monthlyInterest = totalInterest / durationMonths;

    var remainingPrincipal = principalAmount.toDouble();
    var remainingInterest = totalInterest;
    final items = <LoanInstallmentDraft>[];

    for (var i = 1; i <= durationMonths; i++) {
      final dueDate = _addMonths(firstDue, i - 1);
      final isLast = i == durationMonths;
      final principalDue = isLast ? remainingPrincipal : monthlyPrincipal;
      final interestDue = isLast ? remainingInterest : monthlyInterest;
      remainingPrincipal -= principalDue;
      remainingInterest -= interestDue;
      items.add(
        LoanInstallmentDraft(
          installmentNumber: i,
          dueDate: dueDate,
          principalDue: principalDue,
          interestDue: interestDue,
          totalDue: principalDue + interestDue,
        ),
      );
    }

    return items;
  }

  List<LoanInstallmentDraft> _compoundSchedule({
    required int principalAmount,
    required double interestRate,
    required int durationMonths,
    required DateTime firstDue,
  }) {
    final monthlyRate = interestRate / 100 / 12;
    if (monthlyRate == 0) {
      return _fixedSchedule(
        principalAmount: principalAmount,
        interestRate: 0,
        durationMonths: durationMonths,
        firstDue: firstDue,
      );
    }

    final factor = pow(1 + monthlyRate, durationMonths);
    final monthlyInstallment =
        principalAmount * monthlyRate * factor / (factor - 1);
    var remaining = principalAmount.toDouble();
    final items = <LoanInstallmentDraft>[];

    for (var i = 1; i <= durationMonths; i++) {
      final dueDate = _addMonths(firstDue, i - 1);
      final interestDue = remaining * monthlyRate;
      final principalDue =
          i == durationMonths ? remaining : monthlyInstallment - interestDue;
      final totalDue = principalDue + interestDue;
      remaining -= principalDue;
      items.add(
        LoanInstallmentDraft(
          installmentNumber: i,
          dueDate: dueDate,
          principalDue: principalDue,
          interestDue: interestDue,
          totalDue: totalDue,
        ),
      );
    }

    return items;
  }

  DateTime _addMonths(DateTime date, int months) {
    final totalMonths = date.month + months - 1;
    final newYear = date.year + totalMonths ~/ 12;
    final newMonth = totalMonths % 12 + 1;
    return DateTime(newYear, newMonth, date.day);
  }
}
