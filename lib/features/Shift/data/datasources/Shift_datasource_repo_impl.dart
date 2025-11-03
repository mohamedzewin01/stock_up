import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Shift/data/models/request/add_shift_request.dart';
import 'package:stock_up/features/Shift/data/models/request/get_open_shift_request.dart';
import 'package:stock_up/features/Shift/domain/entities/shift_entity.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Shift_datasource_repo.dart';

@Injectable(as: ShiftDatasourceRepo)
class ShiftDatasourceRepoImpl implements ShiftDatasourceRepo {
  final ApiService apiService;

  ShiftDatasourceRepoImpl(this.apiService);

  int userId = CacheService.getData(key: CacheKeys.userId);
  int storeId = CacheService.getData(key: CacheKeys.storeId);

  @override
  Future<Result<AddShiftEntity?>> addShift(double openingBalance) {
    return executeApi(() async {
      AddShiftRequest addShiftRequest = AddShiftRequest(
        userId: userId,
        storeId: storeId,
        openingBalance: openingBalance,
      );
      var response = await apiService.addShift(addShiftRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<GetOpenShiftEntity?>> getOpenUserShift() {
    return executeApi(() async {
      GetOpenShiftRequest getOpenShiftRequest = GetOpenShiftRequest(
        userId: userId,
      );
      var response = await apiService.getOpenUserShift(getOpenShiftRequest);
      return response?.toEntity();
    });
  }
}
