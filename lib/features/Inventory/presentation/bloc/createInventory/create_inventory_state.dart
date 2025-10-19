part of 'create_inventory_cubit.dart';

@immutable
sealed class CreateInventoryState {}

final class CreateInventoryInitial extends CreateInventoryState {}

final class CreateInventoryLoading extends CreateInventoryState {}

final class CreateInventorySuccess extends CreateInventoryState {
  final CreateInventoryAuditEntity? value;

  CreateInventorySuccess({this.value});
}

final class CreateInventoryFailure extends CreateInventoryState {
  final Exception exception;

  CreateInventoryFailure({required this.exception});
}
