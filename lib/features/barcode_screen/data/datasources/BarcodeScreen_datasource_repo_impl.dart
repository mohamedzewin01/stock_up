import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';


import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';
import 'BarcodeScreen_datasource_repo.dart';

@Injectable(as: BarcodeScreenDatasourceRepo)
class BarcodeScreenDatasourceRepoImpl implements BarcodeScreenDatasourceRepo {
  final ApiService apiService;
  BarcodeScreenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String storeId,String query) {
    return executeApi(() async {
      final result = await apiService.smartSearch(query,storeId);
      return result?.toEntity();
    });
  }
}
