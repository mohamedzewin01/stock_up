part of 'Stores_cubit.dart';

@immutable
sealed class StoresState {}

final class StoresInitial extends StoresState {}
final class StoresLoading extends StoresState {}
final class StoresSuccess extends StoresState {
  final AllStoresEntity allStoresEntity;

  StoresSuccess(this.allStoresEntity);
}
final class StoresFailure extends StoresState {
  final Exception exception;

  StoresFailure(this.exception);
}
