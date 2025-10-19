part of 'users_inventory_cubit.dart';

@immutable
sealed class UsersInventoryState {}

final class UsersInventoryInitial extends UsersInventoryState {}

final class UsersInventorySuccess extends UsersInventoryState {
  final GetAllUsersEntity? value;

  UsersInventorySuccess({this.value});
}

final class UsersInventoryLoading extends UsersInventoryState {}

final class UsersInventoryFailure extends UsersInventoryState {
  final Exception exception;

  UsersInventoryFailure({required this.exception});
}
