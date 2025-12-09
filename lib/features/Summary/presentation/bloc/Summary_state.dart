part of 'Summary_cubit.dart';

@immutable
sealed class SummaryState {}

final class SummaryInitial extends SummaryState {}

final class SummaryLoading extends SummaryState {}

final class SummarySuccess extends SummaryState {
  final SummaryEntity? summary;

  SummarySuccess(this.summary);
}

final class SummaryFailure extends SummaryState {
  final Exception exception;

  SummaryFailure(this.exception);
}
