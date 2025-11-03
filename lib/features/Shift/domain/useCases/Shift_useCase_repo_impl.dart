import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

import '../repositories/Shift_repository.dart';
import '../useCases/Shift_useCase_repo.dart';

@Injectable(as: ShiftUseCaseRepo)
class ShiftUseCase implements ShiftUseCaseRepo {
  final ShiftRepository repository;

  ShiftUseCase(this.repository);

  @override
  Future<Result<GetOpenShiftEntity?>> getOpenUserShift() {
    return repository.getOpenUserShift();
  }

  @override
  Future<Result<AddShiftEntity?>> addShift(double openingBalance) {
    return repository.addShift(openingBalance);
  }

  @override
  Future<Result<GetClosedShiftEntity?>> getClosedUserShift() {
    return repository.getClosedUserShift();
  }

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
