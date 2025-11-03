part of 'open_shift_cubit.dart';

@immutable
sealed class OpenShiftState {}

final class OpenShiftInitial extends OpenShiftState {}

final class UserShiftLoading extends OpenShiftState {}

final class UserShiftSuccess extends OpenShiftState {
  final GetOpenShiftEntity? data;

  UserShiftSuccess(this.data);
}

final class UserShiftFailure extends OpenShiftState {
  final Exception exception;

  UserShiftFailure(this.exception);
}
