import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Inventory_useCase_repo.dart';

part 'Inventory_state.dart';

@injectable
class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit(this._inventoryUseCaseRepo) : super(InventoryInitial());
  final InventoryUseCaseRepo _inventoryUseCaseRepo;
}
