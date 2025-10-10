import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';
import '../../domain/useCases/EmployeeBarcodeScreen_useCase_repo.dart';

part 'EmployeeBarcodeScreen_state.dart';

@injectable
class EmployeeBarcodeScreenCubit extends Cubit<EmployeeBarcodeScreenState> {
  EmployeeBarcodeScreenCubit(this._employeeBarcodeScreenUseCaseRepo)
    : super(EmployeeBarcodeScreenInitial());
  final EmployeeBarcodeScreenUseCaseRepo _employeeBarcodeScreenUseCaseRepo;

  Future<void> smartSearch(String query) async {
    emit(EmployeeBarcodeScreenLoading());
    final result = await _employeeBarcodeScreenUseCaseRepo.smartSearch(query);

    switch (result) {
      case Success<SmartSearchEntity?>():
        if (!isClosed) {
          emit(EmployeeBarcodeScreenSuccess(result.data!));
        }

      case Fail<SmartSearchEntity?>():
        if (!isClosed) {
          emit(EmployeeBarcodeScreenFailure(result.exception));
        }
        break;
    }
  }
}
