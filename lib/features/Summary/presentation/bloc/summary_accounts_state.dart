part of 'summary_accounts_cubit.dart';

@immutable
sealed class SummaryAccountsState {}

final class SummaryAccountsInitial extends SummaryAccountsState {}

final class SummaryAccountsLoading extends SummaryAccountsState {}

final class SummaryAccountsSuccess extends SummaryAccountsState {
  final SummaryAccountsEntity? summaryAccountsEntity;

  SummaryAccountsSuccess(this.summaryAccountsEntity);
}

final class SummaryAccountsError extends SummaryAccountsState {
  final Exception exception;

  SummaryAccountsError(this.exception);
}
