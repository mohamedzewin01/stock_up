import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';

part 'create_inventory_state.dart';

@injectable
class CreateInventoryCubit extends Cubit<CreateInventoryState> {
  CreateInventoryCubit(this.inventoryUseCaseRepo)
    : super(CreateInventoryInitial());
  final InventoryUseCaseRepo inventoryUseCaseRepo;

  Future<void> createInventory({required String? notes}) async {
    emit(CreateInventoryLoading());
    final result = await inventoryUseCaseRepo.createInventoryAudit(notes);
    switch (result) {
      case Success<CreateInventoryAuditEntity?>():
        CacheService.setData(
          key: CacheKeys.auditId,
          value: result.data?.audit?.id,
        );
        emit(CreateInventorySuccess(value: result.data));
        break;
      case Fail<CreateInventoryAuditEntity?>():
        emit(CreateInventoryFailure(exception: result.exception));
        break;
    }
  }
}
