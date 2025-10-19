part of 'inventory_user_cubit.dart';

@immutable
sealed class InventoryUserState {}

final class InventoryUserInitial extends InventoryUserState {}

final class InventoryUserLoading extends InventoryUserState {}

final class InventoryUserSuccess extends InventoryUserState {
  final GetInventoryByUserEntity? value;

  InventoryUserSuccess({this.value});
}

final class InventoryUserFailure extends InventoryUserState {
  final Exception exception;

  InventoryUserFailure({required this.exception});
}
