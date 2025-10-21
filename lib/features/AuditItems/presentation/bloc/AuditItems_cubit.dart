import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

import '../../domain/useCases/AuditItems_useCase_repo.dart';

part 'AuditItems_state.dart';

@injectable
class AuditItemsCubit extends Cubit<AuditItemsState> {
  AuditItemsCubit(this._auditItemsUseCaseRepo) : super(AuditItemsInitial());
  final AuditItemsUseCaseRepo _auditItemsUseCaseRepo;

  Future<void> addInventoryAuditItems({
    String? notes,
    required int productId,
    required int quantity,
    required int auditId,
  }) async {
    emit(AuditItemsLoading());
    final result = await _auditItemsUseCaseRepo.addInventoryAuditItems(
      notes: notes,
      productId: productId,
      quantity: quantity,
      auditId: auditId,
    );
    switch (result) {
      case Success<AddInventoryAuditItemsEntity?>():
        emit(AuditItemsSuccess(value: result.data));
        break;
      case Fail<AddInventoryAuditItemsEntity?>():
        emit(AuditItemsFailure(result.exception));
        break;
    }
  }
}
