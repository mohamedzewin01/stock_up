import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/data/datasources/Shift_datasource_repo.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

import '../../domain/repositories/Shift_repository.dart';

@Injectable(as: ShiftRepository)
class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftDatasourceRepo shiftDatasourceRepo;

  ShiftRepositoryImpl(this.shiftDatasourceRepo);

  @override
  Future<Result<AddShiftEntity?>> addShift(double openingBalance) {
    return shiftDatasourceRepo.addShift(openingBalance);
  }

  @override
  Future<Result<GetOpenShiftEntity?>> getOpenUserShift() {
    return shiftDatasourceRepo.getOpenUserShift();
  }

  // implementation
}
