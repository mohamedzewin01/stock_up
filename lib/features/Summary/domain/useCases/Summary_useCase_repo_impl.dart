import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

import '../repositories/Summary_repository.dart';
import '../useCases/Summary_useCase_repo.dart';

@Injectable(as: SummaryUseCaseRepo)
class SummaryUseCase implements SummaryUseCaseRepo {
  final SummaryRepository repository;

  SummaryUseCase(this.repository);

  @override
  Future<Result<SummaryEntity?>> summary(int storeId, String? operationDate) {
    return repository.summary(storeId, operationDate);
  }

  @override
  Future<Result<SummaryAccountsEntity?>> summaryAccounts(
    int storeId,
    String? accountType,
    String? q,
    int? page,
    int? limit,
    bool? hideZero,
  ) {
    return repository.summaryAccounts(
      storeId,
      accountType,
      q,
      page,
      limit,
      hideZero,
    );
  }
}
