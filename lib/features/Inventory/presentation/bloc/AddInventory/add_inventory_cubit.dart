// import 'package:bloc/bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:meta/meta.dart';
// import 'package:stock_up/core/common/api_result.dart';
// import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
// import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';
//
// part 'add_inventory_state.dart';
//
// @injectable
// class AddInventoryCubit extends Cubit<AddInventoryState> {
//   AddInventoryCubit(this.inventoryUseCaseRepo) : super(AddInventoryInitial());
//   final InventoryUseCaseRepo inventoryUseCaseRepo;
//
//   Future<void> addInventoryAuditUsers({
//     required int auditId,
//     required List<int> userIds,
//   }) async {
//     emit(AddInventoryLoading());
//     final result = await inventoryUseCaseRepo.addInventoryAuditUsers(userIds);
//     switch (result) {
//       case Success<AddInventoryAuditUsersEntity?>():
//         emit(AddInventorySuccess(value: result.data));
//         break;
//       case Fail<AddInventoryAuditUsersEntity?>():
//         emit(AddInventoryFailure(exception: result.exception));
//         break;
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';

part 'add_inventory_state.dart';

@injectable
class AddInventoryCubit extends Cubit<AddInventoryState> {
  AddInventoryCubit(this.inventoryUseCaseRepo) : super(AddInventoryInitial());
  final InventoryUseCaseRepo inventoryUseCaseRepo;

  Future<void> addInventoryAuditUsers({
    required int auditId,
    required List<int> userIds,
  }) async {
    emit(AddInventoryLoading());
    final result = await inventoryUseCaseRepo.addInventoryAuditUsers(userIds);
    switch (result) {
      case Success<AddInventoryAuditUsersEntity?>():
        emit(AddInventorySuccess(value: result.data));
        break;
      case Fail<AddInventoryAuditUsersEntity?>():
        emit(AddInventoryFailure(exception: result.exception));
        break;
    }
  }
}
