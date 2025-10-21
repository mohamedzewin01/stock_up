import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';
import 'package:stock_up/features/AuditItems/domain/useCases/AuditItems_useCase_repo.dart';

part 'update_items_status_state.dart';

@injectable
class UpdateItemsStatusCubit extends Cubit<UpdateItemsStatusState> {
  UpdateItemsStatusCubit(this.repository) : super(UpdateItemsStatusInitial());
  final AuditItemsUseCaseRepo repository;

  Future<void> updateInventoryItemsStatus({
    required int auditId,
    required int itemId,
    required String status,
  }) async {
    emit(UpdateItemsStatusLoading());
    final result = await repository.updateInventoryItemsStatus(
      auditId: auditId,
      itemId: itemId,
      status: status,
    );
    switch (result) {
      case Success<UpdateInventoryStatusEntity?>():
        emit(UpdateItemsStatusLoaded(result.data));
        break;
      case Fail<UpdateInventoryStatusEntity?>():
        emit(UpdateItemsStatusError(result.exception));
        break;
    }
  }
}
