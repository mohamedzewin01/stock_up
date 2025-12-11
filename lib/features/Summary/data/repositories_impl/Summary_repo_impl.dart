import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/data/datasources/Summary_datasource_repo.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

import '../../domain/repositories/Summary_repository.dart';

@Injectable(as: SummaryRepository)
class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryDatasourceRepo summaryDatasourceRepo;

  SummaryRepositoryImpl(this.summaryDatasourceRepo);

  @override
  Future<Result<SummaryEntity?>> summary(int storeId, String? operationDate) {
    return summaryDatasourceRepo.summary(storeId, operationDate);
  }
}
