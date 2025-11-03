import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';

import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';

import '../repositories/Transaction_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Transaction_useCase_repo.dart';

@Injectable(as: TransactionUseCaseRepo)
class TransactionUseCase implements TransactionUseCaseRepo {
  final TransactionRepository repository;

  TransactionUseCase(this.repository);

  @override
  Future<Result<AddTransactionEntity?>> addTransaction(
    AddTransactionRequest addTransactionRequest,
  ) {
    return repository.addTransaction(addTransactionRequest);
  }
}
