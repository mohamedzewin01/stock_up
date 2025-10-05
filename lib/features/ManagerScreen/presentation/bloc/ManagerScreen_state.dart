part of 'ManagerScreen_cubit.dart';

@immutable
sealed class ManagerScreenState {}

final class ManagerScreenInitial extends ManagerScreenState {}
final class ManagerScreenLoading extends ManagerScreenState {}
final class ManagerScreenSuccess extends ManagerScreenState {}
final class ManagerScreenFailure extends ManagerScreenState {
  final Exception exception;

  ManagerScreenFailure(this.exception);
}
