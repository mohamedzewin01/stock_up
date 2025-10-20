import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';
import 'package:stock_up/features/AuditItems/domain/useCases/AuditItems_useCase_repo.dart';

part 'search_products_state.dart';

@injectable
class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit(this._auditItemsUseCaseRepo)
    : super(SearchProductsInitial());
  final AuditItemsUseCaseRepo _auditItemsUseCaseRepo;

  Future<void> search(String? query, int? page) async {
    emit(SearchProductsLoading());
    final result = await _auditItemsUseCaseRepo.search(query, page);
    switch (result) {
      case Success<SearchProductsEntity?>():
        emit(SearchProductsSuccess(searchProductsEntity: result.data));
        break;
      case Fail<SearchProductsEntity?>():
        emit(SearchProductsFailure(result.exception));
        break;
    }
  }
}
