import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

abstract class SummaryDatasourceRepo {
  Future<Result<SummaryEntity?>> summary(
    int storeId,
    String? startDate,
    String? endDate,
  );
}
