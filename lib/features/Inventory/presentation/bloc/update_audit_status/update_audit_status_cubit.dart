import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';

part 'update_audit_status_state.dart';

@injectable
class UpdateAuditStatusCubit extends Cubit<UpdateAuditStatusState> {
  UpdateAuditStatusCubit(this.inventoryUseCaseRepo)
    : super(UpdateAuditStatusInitial());
  final InventoryUseCaseRepo inventoryUseCaseRepo;

  Future<void> updateAuditStatus({required int auditId}) async {
    emit(UpdateAuditStatusLoading());
    final result = await inventoryUseCaseRepo.updateAuditStatus(
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
