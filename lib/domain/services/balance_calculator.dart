import 'package:expense_manage/data/database/app_database.dart';

class BalanceCalculator {
  const BalanceCalculator();

  int nonTransferDelta({
    required AccountType accountType,
    required TransactionType transactionType,
    required int amount,
  }) {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }
    if (transactionType == TransactionType.transfer) {
      throw ArgumentError.value(transactionType, 'transactionType');
    }

    final isCreditCard = accountType == AccountType.creditCard;
    final isIncome = transactionType == TransactionType.income;

    if (isCreditCard) {
      return isIncome ? -amount : amount;
    }

    return isIncome ? amount : -amount;
  }

  int transferDelta({
    required AccountType accountType,
    required bool isIncoming,
    required int amount,
  }) {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be >= 0');
    }

    final isCreditCard = accountType == AccountType.creditCard;
    if (isCreditCard) {
      return isIncoming ? -amount : amount;
    }

    return isIncoming ? amount : -amount;
  }
}
