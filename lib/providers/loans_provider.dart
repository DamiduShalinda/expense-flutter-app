import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

final activeLoansProvider =
    NotifierProvider.autoDispose<
      ActiveLoansNotifier,
      AsyncValue<List<Loan>>
    >(ActiveLoansNotifier.new);

class ActiveLoansNotifier
    extends AutoDisposeNotifier<AsyncValue<List<Loan>>> {
  StreamSubscription<List<Loan>>? _subscription;

  @override
  AsyncValue<List<Loan>> build() {
    final repo = ref.watch(loanRepositoryProvider);
    _subscription = repo.watchActiveLoans().listen(
      (loans) => state = AsyncData(loans),
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}

final closedLoansProvider =
    NotifierProvider.autoDispose<
      ClosedLoansNotifier,
      AsyncValue<List<Loan>>
    >(ClosedLoansNotifier.new);

final totalOutstandingLoansProvider = Provider.autoDispose<AsyncValue<int>>((
  ref,
) {
  final loansAsync = ref.watch(activeLoansProvider);
  return loansAsync.whenData(
    (loans) => loans.fold<int>(0, (sum, loan) => sum + loan.outstandingAmount),
  );
});

class ClosedLoansNotifier
    extends AutoDisposeNotifier<AsyncValue<List<Loan>>> {
  StreamSubscription<List<Loan>>? _subscription;

  @override
  AsyncValue<List<Loan>> build() {
    final repo = ref.watch(loanRepositoryProvider);
    _subscription = repo.watchClosedLoans().listen(
      (loans) => state = AsyncData(loans),
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncLoading();
  }
}

class LoanDetailsState {
  const LoanDetailsState({
    required this.loan,
    required this.installments,
    required this.payments,
  });

  final Loan loan;
  final List<LoanInstallment> installments;
  final List<LoanPayment> payments;
}

final loanDetailsProvider = NotifierProvider.autoDispose
    .family<LoanDetailsNotifier, AsyncValue<LoanDetailsState>, int>(
      LoanDetailsNotifier.new,
    );

class LoanDetailsNotifier
    extends AutoDisposeFamilyNotifier<AsyncValue<LoanDetailsState>, int> {
  StreamSubscription<Loan?>? _loanSubscription;
  StreamSubscription<List<LoanInstallment>>? _installmentsSubscription;
  StreamSubscription<List<LoanPayment>>? _paymentsSubscription;
  Loan? _loan;
  List<LoanInstallment>? _installments;
  List<LoanPayment>? _payments;

  @override
  AsyncValue<LoanDetailsState> build(int loanId) {
    final loansRepo = ref.watch(loanRepositoryProvider);
    final paymentsRepo = ref.watch(loanPaymentRepositoryProvider);

    _loanSubscription = loansRepo.watchLoan(loanId).listen(
      (loan) {
        _loan = loan;
        _rebuildState(loanId);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    _installmentsSubscription = loansRepo.watchInstallments(loanId).listen(
      (items) {
        _installments = items;
        _rebuildState(loanId);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    _paymentsSubscription = paymentsRepo.watchPaymentsForLoan(loanId).listen(
      (items) {
        _payments = items;
        _rebuildState(loanId);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );

    ref.onDispose(() {
      _loanSubscription?.cancel();
      _installmentsSubscription?.cancel();
      _paymentsSubscription?.cancel();
    });

    return const AsyncLoading();
  }

  void _rebuildState(int loanId) {
    final loan = _loan;
    final installments = _installments;
    final payments = _payments;
    if (loan == null) {
      state = AsyncError(
        StateError('Loan not found: $loanId'),
        StackTrace.current,
      );
      return;
    }
    if (installments == null || payments == null) {
      state = const AsyncLoading();
      return;
    }
    state = AsyncData(
      LoanDetailsState(
        loan: loan,
        installments: installments,
        payments: payments,
      ),
    );
  }
}
