part of 'Inventory_cubit.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}
final class InventoryLoading extends InventoryState {}
final class InventorySuccess extends InventoryState {}
final class InventoryFailure extends InventoryState {
  final Exception exception;

  InventoryFailure(this.exception);
}
