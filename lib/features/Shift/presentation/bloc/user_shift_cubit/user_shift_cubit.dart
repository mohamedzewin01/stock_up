import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';
import 'package:stock_up/features/Shift/domain/useCases/Shift_useCase_repo.dart';

part 'user_shift_state.dart';

class UserShiftCubit extends Cubit<UserShiftState> {
  UserShiftCubit(this._shiftUseCaseRepo) : super(UserShiftInitial());
  final ShiftUseCaseRepo _shiftUseCaseRepo;

  Future<void> getOpenUserShift() async {
    emit(UserShiftLoading());
    final result = await _shiftUseCaseRepo.getOpenUserShift();
    switch (result) {
      case Success<GetOpenShiftEntity?>():
        {
          if (!isClosed) {
            emit(UserShiftSuccess(result.data!));
          }
        }

      case Fail<GetOpenShiftEntity?>():
        {
          if (!isClosed) {
            emit(UserShiftFailure(result.exception));
          }
        }
        break;
    }
  }
}
