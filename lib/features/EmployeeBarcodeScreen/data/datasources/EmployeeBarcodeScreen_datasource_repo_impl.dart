import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';

import 'EmployeeBarcodeScreen_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: EmployeeBarcodeScreenDatasourceRepo)
class EmployeeBarcodeScreenDatasourceRepoImpl implements EmployeeBarcodeScreenDatasourceRepo {
  final ApiService apiService;
  EmployeeBarcodeScreenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String query) {
    return executeApi(() async {
      final result = await apiService.smartSearch(query);
      return result?.toEntity();
    });
  }
}
