import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

import '../../domain/useCases/Barcodes_useCase_repo.dart';

part 'Barcodes_state.dart';

@injectable
class BarcodesCubit extends Cubit<BarcodesState> {
  BarcodesCubit(this._barcodesUseCaseRepo) : super(BarcodesInitial());
  final BarcodesUseCaseRepo _barcodesUseCaseRepo;

  Future<void> addBarcode({
    required String barcode,
    String? barcodeType,
    required int productId,
    double? unitPrice,
    int? unitQuantity,
  }) async {
    emit(AddBarcodesLoading());
    final result = await _barcodesUseCaseRepo.addBarcode(
      barcode: barcode,
      barcodeType: barcodeType,
      productId: productId,
      unitPrice: unitPrice,
      unitQuantity: unitQuantity,
    );
    switch (result) {
      case Success<AddBarcodeEntity?>():
        emit(AddBarcodesSuccess(result.data));

        break;
      case Fail<AddBarcodeEntity?>():
        emit(AddBarcodesFailure(result.exception));
        break;
    }
  }

  Future<void> deleteBarcode({
    required String barcode,
    required int productId,
  }) async {
    emit(DeleteBarcodesLoading());
    final result = await _barcodesUseCaseRepo.deleteBarcode(
      barcode: barcode,
      productId: productId,
    );
    switch (result) {
      case Success<DeleteBarcodeEntity?>():
        emit(DeleteBarcodesSuccess(result.data));

        break;
      case Fail<DeleteBarcodeEntity?>():
        emit(DeleteBarcodesFailure(result.exception));
        break;
    }
  }
}
