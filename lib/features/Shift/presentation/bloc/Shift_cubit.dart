import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

import '../../domain/useCases/Shift_useCase_repo.dart';

part 'Shift_state.dart';

@injectable
class ShiftCubit extends Cubit<ShiftState> {
  ShiftCubit(this._shiftUseCaseRepo) : super(ShiftInitial());
  final ShiftUseCaseRepo _shiftUseCaseRepo;

  Future<void> addShift({
    required int userId,
    required int storeId,
    required double openingBalance,
  }) async {
    emit(ShiftLoading());
    final result = await _shiftUseCaseRepo.addShift(openingBalance);
    switch (result) {
      case Success<AddShiftEntity?>():
        {
          if (!isClosed) {
            emit(ShiftSuccess(result.data!));
          }
        }

      case Fail<AddShiftEntity?>():
        {
          if (!isClosed) {
            emit(ShiftFailure(result.exception));
          }
        }
        break;
    }
  }
}
