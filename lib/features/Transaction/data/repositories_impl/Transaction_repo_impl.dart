import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Transaction/data/datasources/Transaction_datasource_repo.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';
import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';
import '../../domain/repositories/Transaction_repository.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasourceRepo transactionDatasourceRepo;

  TransactionRepositoryImpl(this.transactionDatasourceRepo);

  @override
  Future<Result<AddTransactionEntity?>> addTransaction(
    AddTransactionRequest addTransactionRequest,
  ) {
    return transactionDatasourceRepo.addTransaction(addTransactionRequest);
  }

  // implementation
}
