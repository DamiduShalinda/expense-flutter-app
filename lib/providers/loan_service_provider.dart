import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/domain/services/loan_service.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final loanServiceProvider = Provider<LoanService>((ref) {
  return LoanService(
    loanRepository: ref.watch(loanRepositoryProvider),
    transactionsRepository: ref.watch(transactionsRepositoryProvider),
    categoriesRepository: ref.watch(categoriesRepositoryProvider),
  );
});
