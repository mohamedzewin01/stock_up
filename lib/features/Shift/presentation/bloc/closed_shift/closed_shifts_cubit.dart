import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';
import 'package:stock_up/features/Shift/domain/useCases/Shift_useCase_repo.dart';

part 'closed_shifts_state.dart';

@injectable
class ClosedShiftsCubit extends Cubit<ClosedShiftsState> {
  ClosedShiftsCubit(this._shiftUseCaseRepo) : super(ClosedShiftsInitial());
  final ShiftUseCaseRepo _shiftUseCaseRepo;

  Future<void> getClosedUserShift() async {
    emit(ClosedShiftLoading());
    final result = await _shiftUseCaseRepo.getClosedUserShift();
    switch (result) {
      case Success<GetClosedShiftEntity?>():
        {
          if (!isClosed) {
            emit(ClosedShiftSuccess(result.data!));
          }
        }

      case Fail<GetClosedShiftEntity?>():
        {
          if (!isClosed) {
            emit(ClosedShiftFailure(result.exception));
          }
        }
        break;
    }
  }
}
