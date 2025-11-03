import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Transaction/data/models/request/add_transaction_request.dart';
import 'package:stock_up/features/Transaction/domain/entities/transaction_entity.dart';
import '../../domain/useCases/Transaction_useCase_repo.dart';

part 'Transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._transactionUseCaseRepo) : super(TransactionInitial());
  final TransactionUseCaseRepo _transactionUseCaseRepo;

  Future<void> addTransaction({
    required int shiftId,
    required List<Transactions>? transactions,
  }) async {
    emit(TransactionLoading());
    AddTransactionRequest addTransactionRequest = AddTransactionRequest(
      shiftId: shiftId,
      transactions: transactions,
    );
    var result = await _transactionUseCaseRepo.addTransaction(
      addTransactionRequest,
    );
    switch (result) {
      case Success<AddTransactionEntity?>():
        {
          if (!isClosed) {
            emit(TransactionSuccess(result.data!));
          }
        }

      case Fail<AddTransactionEntity?>():
        {
          if (!isClosed) {
            emit(TransactionFailure(result.exception));
          }
        }
        break;
    }
  }
}
