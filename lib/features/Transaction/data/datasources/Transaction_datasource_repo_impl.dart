import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';
import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';
import 'Transaction_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: TransactionDatasourceRepo)
class TransactionDatasourceRepoImpl implements TransactionDatasourceRepo {
  final ApiService apiService;

  TransactionDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddTransactionEntity?>> addTransaction(
      AddTransactionRequest addTransactionRequest) {
    return executeApi(() async {
      var response = await apiService.addTransaction(addTransactionRequest);
      return response?.toEntity();
    },);
  }
}
