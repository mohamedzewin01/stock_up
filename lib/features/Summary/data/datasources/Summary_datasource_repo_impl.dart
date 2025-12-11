import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/data/models/request/summary_request.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Summary_datasource_repo.dart';

@Injectable(as: SummaryDatasourceRepo)
class SummaryDatasourceRepoImpl implements SummaryDatasourceRepo {
  final ApiService apiService;

  SummaryDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<SummaryEntity?>> summary(int storeId, String? operationDate) {
    return executeApi(() async {
      final response = await apiService.summary(
        SummaryRequest(storeId: storeId, operationDate: operationDate),
      );
      return response?.toEntity();
    });
  }
}
