import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Stores/data/datasources/Stores_datasource_repo.dart';
import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';
import '../../domain/repositories/Stores_repository.dart';

@Injectable(as: StoresRepository)
class StoresRepositoryImpl implements StoresRepository {
  final StoresDatasourceRepo storesDatasourceRepo;
  StoresRepositoryImpl(this.storesDatasourceRepo);

  @override
  Future<Result<AllStoresEntity?>> getAllStores() {
   return storesDatasourceRepo.getAllStores();
  }


  // implementation
}
