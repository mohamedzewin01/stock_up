import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';
import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Result<AddTransactionEntity?>> addTransaction(
    AddTransactionRequest addTransactionRequest,
  );
}
