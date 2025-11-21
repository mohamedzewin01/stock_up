import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/data/datasources/Barcodes_datasource_repo.dart';
import 'package:stock_up/features/Barcodes/data/models/request/add_barcode_request.dart';
import 'package:stock_up/features/Barcodes/data/models/request/delete_barcode_request.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

import '../../domain/repositories/Barcodes_repository.dart';

@Injectable(as: BarcodesRepository)
class BarcodesRepositoryImpl implements BarcodesRepository {
  final BarcodesDatasourceRepo barcodesDatasourceRepo;

  BarcodesRepositoryImpl(this.barcodesDatasourceRepo);

  @override
  Future<Result<AddBarcodeEntity?>> addBarcode(
    AddBarcodeRequest addBarcodeRequest,
  ) {
    return barcodesDatasourceRepo.addBarcode(addBarcodeRequest);
  }

  @override
  Future<Result<DeleteBarcodeEntity?>> deleteBarcode(
    DeleteBarcodeRequest deleteBarcoderRequest,
  ) {
    return barcodesDatasourceRepo.deleteBarcode(deleteBarcoderRequest);
  }

  // implementation
}
