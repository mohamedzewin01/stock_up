import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';

part 'users_inventory_state.dart';

@injectable
class UsersInventoryCubit extends Cubit<UsersInventoryState> {
  UsersInventoryCubit(this.inventoryUseCaseRepo)
    : super(UsersInventoryInitial());
  final InventoryUseCaseRepo inventoryUseCaseRepo;

  Future<void> getAllUsers() async {
    emit(UsersInventoryLoading());
    final result = await inventoryUseCaseRepo.getAllUsers();
    switch (result) {
      case Success<GetAllUsersEntity?>():
        emit(UsersInventorySuccess(value: result.data));
        break;
      case Fail<GetAllUsersEntity?>():
        emit(UsersInventoryFailure(exception: result.exception));
        break;
    }
  }
}
