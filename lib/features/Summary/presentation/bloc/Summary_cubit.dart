import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Summary/domain/entities/summary_entities.dart';

import '../../domain/useCases/Summary_useCase_repo.dart';

part 'Summary_state.dart';

@injectable
class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit(this._summaryUseCaseRepo) : super(SummaryInitial());
  final SummaryUseCaseRepo _summaryUseCaseRepo;

  Future<void> summary(int storeId, String? operationDate) async {
    emit(SummaryLoading());
    final result = await _summaryUseCaseRepo.summary(storeId, operationDate);
    switch (result) {
      case Success<SummaryEntity?>():
        emit(SummarySuccess(result.data));
        break;
      case Fail<SummaryEntity?>():
        emit(SummaryFailure(result.exception));
        break;
    }
    //
  }
}
