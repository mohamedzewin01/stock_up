part of 'add_inventory_cubit.dart';

@immutable
sealed class AddInventoryState {}

final class AddInventoryInitial extends AddInventoryState {}

final class AddInventoryLoading extends AddInventoryState {}

final class AddInventorySuccess extends AddInventoryState {
  final AddInventoryAuditUsersEntity? value;

  AddInventorySuccess({this.value});
}

final class AddInventoryFailure extends AddInventoryState {
  final Exception exception;

  AddInventoryFailure({required this.exception});
}
