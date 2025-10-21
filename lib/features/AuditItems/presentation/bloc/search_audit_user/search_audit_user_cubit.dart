import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';
import 'package:stock_up/features/AuditItems/domain/useCases/AuditItems_useCase_repo.dart';

part 'search_audit_user_state.dart';

@Injectable()
class SearchAuditUserCubit extends Cubit<SearchAuditUserState> {
  SearchAuditUserCubit(this._auditItemsUseCaseRepo)
    : super(SearchAuditUserInitial());
  final AuditItemsUseCaseRepo _auditItemsUseCaseRepo;

  Future<void> searchAuditUser() async {
    emit(SearchAuditUserLoading());
    final result = await _auditItemsUseCaseRepo.searchAuditUser();
    switch (result) {
      case Success<SearchAuditUserEntity?>():
        emit(SearchAuditUserSuccess(result.data));
        break;
      case Fail<SearchAuditUserEntity?>():
        emit(SearchAuditUserFailure(result.exception));
        break;
    }
  }
}
