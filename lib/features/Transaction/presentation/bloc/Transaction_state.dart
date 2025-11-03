part of 'Transaction_cubit.dart';

@immutable
sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionSuccess extends TransactionState {
  final AddTransactionEntity? addTransactionEntity;

  TransactionSuccess(this.addTransactionEntity);

}

final class TransactionFailure extends TransactionState {
  final Exception exception;

  TransactionFailure(this.exception);
}
