import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';

abstract class StoresUseCaseRepo {
  Future<Result<AllStoresEntity?>>getAllStores();
}
