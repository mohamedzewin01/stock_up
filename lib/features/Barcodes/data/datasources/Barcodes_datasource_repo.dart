import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/data/models/request/add_barcode_request.dart';
import 'package:stock_up/features/Barcodes/data/models/request/delete_barcode_request.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

abstract class BarcodesDatasourceRepo {
  Future<Result<AddBarcodeEntity?>> addBarcode(
    AddBarcodeRequest addBarcodeRequest,
  );

  Future<Result<DeleteBarcodeEntity?>> deleteBarcode(
    DeleteBarcodeRequest deleteBarcoderRequest,
  );
}
