import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';
import 'package:stock_up/features/Summary/domain/useCases/Summary_useCase_repo.dart';

part 'summary_accounts_state.dart';

@injectable
class SummaryAccountsCubit extends Cubit<SummaryAccountsState> {
  SummaryAccountsCubit(this._summaryUseCaseRepo)
    : super(SummaryAccountsInitial());
  final SummaryUseCaseRepo _summaryUseCaseRepo;

  Future<void> summaryAccounts(
    int storeId,
    String? accountType,
    String? q,
    int? page,
    int? limit,
    bool? hideZero,
  ) async {
    emit(SummaryAccountsLoading());
    final result = await _summaryUseCaseRepo.summaryAccounts(
      storeId,
      accountType,
      q,
      page,
      limit,
      hideZero,
    );
    switch (result) {
      case Success<SummaryAccountsEntity?>():
        emit(SummaryAccountsSuccess(result.data));
        break;
      case Fail<SummaryAccountsEntity?>():
        emit(SummaryAccountsError(result.exception));
        break;
    }
  }
}
