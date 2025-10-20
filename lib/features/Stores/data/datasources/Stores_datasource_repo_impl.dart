import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';
import 'Stores_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoresDatasourceRepo)
class StoresDatasourceRepoImpl implements StoresDatasourceRepo {
  final ApiService apiService;
  StoresDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AllStoresEntity?>> getAllStores() {
   return executeApi(() async {
    final result = await apiService.getStore();
    return result?.toEntity();
   });
  }
}
