import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';
import '../../domain/useCases/Stores_useCase_repo.dart';

part 'Stores_state.dart';

@injectable
class StoresCubit extends Cubit<StoresState> {
  StoresCubit(this._storesUseCaseRepo) : super(StoresInitial());
  final StoresUseCaseRepo _storesUseCaseRepo;


  Future<void> getAllStores() async {
    emit(StoresLoading());
    final result = await _storesUseCaseRepo.getAllStores();
    switch (result) {
      case Success<AllStoresEntity?>():
        if (!isClosed) {
          emit(StoresSuccess(result.data!));
        }

      case Fail<AllStoresEntity?>():
        if (!isClosed) {
          emit(StoresFailure(result.exception));
        }
        break;
    }
  }
}
