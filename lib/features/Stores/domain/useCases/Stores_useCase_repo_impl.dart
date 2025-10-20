import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/Stores/domain/entities/stores_entities.dart';

import '../repositories/Stores_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Stores_useCase_repo.dart';

@Injectable(as: StoresUseCaseRepo)
class StoresUseCase implements StoresUseCaseRepo {
  final StoresRepository repository;

  StoresUseCase(this.repository);

  @override
  Future<Result<AllStoresEntity?>> getAllStores() {
   return repository.getAllStores();
  }


}
