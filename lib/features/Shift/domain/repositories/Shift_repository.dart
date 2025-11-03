import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<Result<AddShiftEntity?>> addShift(double openingBalance);

  Future<Result<GetOpenShiftEntity?>> getOpenUserShift();
}
