import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';
import 'package:stock_up/features/AuditItems/domain/useCases/AuditItems_useCase_repo.dart';

part 'update_audit_status_state.dart';

@injectable
class UpdateAuditStatusCubit extends Cubit<UpdateAuditStatusState> {
  UpdateAuditStatusCubit(this.auditItemsUseCaseRepo)
    : super(UpdateAuditStatusInitial());
  final AuditItemsUseCaseRepo auditItemsUseCaseRepo;

  Future<void> updateAuditStatus({required int auditId}) async {
    emit(UpdateAuditStatusLoading());
    final result = await auditItemsUseCaseRepo.updateAuditStatus(
      auditId: auditId,
    );
    switch (result) {
      case Success<UpdateAuditStatusEntity?>():
        emit(UpdateAuditStatusLoaded(result.data));
        break;
      case Fail<UpdateAuditStatusEntity?>():
        emit(UpdateAuditStatusError(result.exception));
        break;
    }
  }
}
