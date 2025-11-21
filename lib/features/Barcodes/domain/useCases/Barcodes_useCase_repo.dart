import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

abstract class BarcodesUseCaseRepo {
  Future<Result<AddBarcodeEntity?>> addBarcode({
    required String barcode,
    String? barcodeType,
    required int productId,
    double? unitPrice,
    int? unitQuantity,
  });

  Future<Result<DeleteBarcodeEntity?>> deleteBarcode({
    required String barcode,
    required int productId,
  });
}
