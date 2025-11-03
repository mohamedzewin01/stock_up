part of 'Shift_cubit.dart';

@immutable
sealed class ShiftState {}

final class ShiftInitial extends ShiftState {}
final class ShiftLoading extends ShiftState {}
final class ShiftSuccess extends ShiftState {
  final AddShiftEntity? addShiftEntity;
  ShiftSuccess(this.addShiftEntity);
}
final class ShiftFailure extends ShiftState {
  final Exception exception;

  ShiftFailure(this.exception);
}
