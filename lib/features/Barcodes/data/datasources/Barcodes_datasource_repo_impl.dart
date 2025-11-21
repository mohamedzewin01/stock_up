import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Barcodes/data/models/request/add_barcode_request.dart';
import 'package:stock_up/features/Barcodes/data/models/request/delete_barcode_request.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Barcodes_datasource_repo.dart';

@Injectable(as: BarcodesDatasourceRepo)
class BarcodesDatasourceRepoImpl implements BarcodesDatasourceRepo {
  final ApiService apiService;

  BarcodesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddBarcodeEntity?>> addBarcode(
    AddBarcodeRequest addBarcodeRequest,
  ) {
    return executeApi(() async {
      final result = await apiService.addBarcode(addBarcodeRequest);
      return result?.toEntity();
    });
  }

  @override
  Future<Result<DeleteBarcodeEntity?>> deleteBarcode(
    DeleteBarcodeRequest deleteBarcoderRequest,
  ) {
    return executeApi(() async {
      final result = await apiService.deleteBarcode(deleteBarcoderRequest);
      return result?.toEntity();
    });
  }
}
