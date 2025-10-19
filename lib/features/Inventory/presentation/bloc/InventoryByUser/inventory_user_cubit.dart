import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';
import 'package:stock_up/features/Inventory/domain/useCases/Inventory_useCase_repo.dart';

part 'inventory_user_state.dart';

@injectable
class InventoryUserCubit extends Cubit<InventoryUserState> {
  InventoryUserCubit(this.inventoryUseCaseRepo) : super(InventoryUserInitial());
  final InventoryUseCaseRepo inventoryUseCaseRepo;

  Future<void> getInventoryByUser() async {
    emit(InventoryUserLoading());
    final result = await inventoryUseCaseRepo.getInventoryByUser();
    switch (result) {
      case Success<GetInventoryByUserEntity?>():
        emit(InventoryUserSuccess(value: result.data));
        break;
      case Fail<GetInventoryByUserEntity?>():
        emit(InventoryUserFailure(exception: result.exception));
        break;
    }
  }
}
