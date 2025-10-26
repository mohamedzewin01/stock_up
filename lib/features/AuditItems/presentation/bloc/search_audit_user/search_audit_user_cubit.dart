import 'package:flutter_bloc/flutter_bloc.dart';
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

  static SearchAuditUserCubit get(context) => BlocProvider.of(context);

  int auditId = 0;

  Future<void> searchAuditUser() async {
    emit(SearchAuditUserLoading());
    final result = await _auditItemsUseCaseRepo.searchAuditUser();
    switch (result) {
      case Success<SearchAuditUserEntity?>():
        auditId = result.data!.data?[0].auditId ?? 0;
        emit(SearchAuditUserSuccess(result.data));

        break;
      case Fail<SearchAuditUserEntity?>():
        emit(SearchAuditUserFailure(result.exception));
        break;
    }
  }
}
