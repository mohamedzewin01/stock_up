part of 'ManagerHome_cubit.dart';

@immutable
sealed class ManagerHomeState {}

final class ManagerHomeInitial extends ManagerHomeState {}
final class ManagerHomeLoading extends ManagerHomeState {}
final class ManagerHomeSuccess extends ManagerHomeState {}
final class ManagerHomeFailure extends ManagerHomeState {
  final Exception exception;

  ManagerHomeFailure(this.exception);
}
