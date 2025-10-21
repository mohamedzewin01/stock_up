part of 'update_items_status_cubit.dart';

@immutable
sealed class UpdateItemsStatusState {}

final class UpdateItemsStatusInitial extends UpdateItemsStatusState {}

final class UpdateItemsStatusLoading extends UpdateItemsStatusState {}

final class UpdateItemsStatusLoaded extends UpdateItemsStatusState {
  final UpdateInventoryStatusEntity? data;

  UpdateItemsStatusLoaded(this.data);
}

final class UpdateItemsStatusError extends UpdateItemsStatusState {
  final Exception message;

  UpdateItemsStatusError(this.message);
}
