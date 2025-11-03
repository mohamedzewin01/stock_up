part of 'user_shift_cubit.dart';

@immutable
sealed class UserShiftState {}

final class UserShiftInitial extends UserShiftState {}

final class UserShiftLoading extends UserShiftState {}

final class UserShiftSuccess extends UserShiftState {
  final GetOpenShiftEntity? data;

  UserShiftSuccess(this.data);
}

final class UserShiftFailure extends UserShiftState {
  final Exception exception;

  UserShiftFailure(this.exception);
}
