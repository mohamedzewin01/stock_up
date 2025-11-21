part of 'Barcodes_cubit.dart';

@immutable
sealed class BarcodesState {}

final class BarcodesInitial extends BarcodesState {}

final class AddBarcodesLoading extends BarcodesState {}

final class AddBarcodesSuccess extends BarcodesState {
  final AddBarcodeEntity? addBarcodeEntity;

  AddBarcodesSuccess(this.addBarcodeEntity);
}

final class AddBarcodesFailure extends BarcodesState {
  final Exception exception;

  AddBarcodesFailure(this.exception);
}

final class DeleteBarcodesLoading extends BarcodesState {}

final class DeleteBarcodesSuccess extends BarcodesState {
  final DeleteBarcodeEntity? deleteBarcodeEntity;

  DeleteBarcodesSuccess(this.deleteBarcodeEntity);
}

final class DeleteBarcodesFailure extends BarcodesState {
  final Exception exception;

  DeleteBarcodesFailure(this.exception);
}
