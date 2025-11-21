import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/data/models/request/add_barcode_request.dart';
import 'package:stock_up/features/Barcodes/data/models/request/delete_barcode_request.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

import '../repositories/Barcodes_repository.dart';
import '../useCases/Barcodes_useCase_repo.dart';

@Injectable(as: BarcodesUseCaseRepo)
class BarcodesUseCase implements BarcodesUseCaseRepo {
  final BarcodesRepository repository;

  BarcodesUseCase(this.repository);

  @override
  Future<Result<AddBarcodeEntity?>> addBarcode({
    required String barcode,
    String? barcodeType,
    required int productId,
    double? unitPrice,
    int? unitQuantity,
  }) {
    return repository.addBarcode(
      AddBarcodeRequest(
        barcode: barcode,
        barcodeType: barcodeType,
        productId: productId,
        unitPrice: unitPrice,
        unitQuantity: unitQuantity,
      ),
    );
  }

  @override
  Future<Result<DeleteBarcodeEntity?>> deleteBarcode({
    required String barcode,
    required int productId,
  }) {
    return repository.deleteBarcode(
      DeleteBarcodeRequest(barcode: barcode, productId: productId),
    );
  }
}
