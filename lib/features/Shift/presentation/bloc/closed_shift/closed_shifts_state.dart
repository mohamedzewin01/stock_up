part of 'closed_shifts_cubit.dart';

@immutable
sealed class ClosedShiftsState {}

final class ClosedShiftsInitial extends ClosedShiftsState {}

final class ClosedShiftLoading extends ClosedShiftsState {}

final class ClosedShiftSuccess extends ClosedShiftsState {
  final GetClosedShiftEntity? data;

  ClosedShiftSuccess(this.data);
}

final class ClosedShiftFailure extends ClosedShiftsState {
  final Exception exception;

  ClosedShiftFailure(this.exception);
}
