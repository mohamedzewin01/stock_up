part of 'AuditItems_cubit.dart';

@immutable
sealed class AuditItemsState {}

final class AuditItemsInitial extends AuditItemsState {}

final class AuditItemsLoading extends AuditItemsState {}

final class AuditItemsSuccess extends AuditItemsState {
  final AddInventoryAuditItemsEntity? value;

  AuditItemsSuccess({this.value});
}

final class AuditItemsFailure extends AuditItemsState {
  final Exception exception;

  AuditItemsFailure(this.exception);
}
