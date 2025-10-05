part of 'EmployeeBarcodeScreen_cubit.dart';

@immutable
sealed class EmployeeBarcodeScreenState {}

final class EmployeeBarcodeScreenInitial extends EmployeeBarcodeScreenState {}
final class EmployeeBarcodeScreenLoading extends EmployeeBarcodeScreenState {}
final class EmployeeBarcodeScreenSuccess extends EmployeeBarcodeScreenState {}
final class EmployeeBarcodeScreenFailure extends EmployeeBarcodeScreenState {
  final Exception exception;

  EmployeeBarcodeScreenFailure(this.exception);
}
