import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';

import '../repositories/Products_repository.dart';
import '../useCases/Products_useCase_repo.dart';

@Injectable(as: ProductsUseCaseRepo)
class ProductsUseCase implements ProductsUseCaseRepo {
  final ProductsRepository repository;

  ProductsUseCase(this.repository);

  @override
  Future<Result<GetAllProductsEntity?>> getAllProducts() {
    return repository.getAllProducts();
  }

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
