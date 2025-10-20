import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Products/data/datasources/Products_datasource_repo.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';

import '../../domain/repositories/Products_repository.dart';

@Injectable(as: ProductsRepository)
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasourceRepo productsDatasourceRepo;

  ProductsRepositoryImpl(this.productsDatasourceRepo);

  @override
  Future<Result<GetAllProductsEntity?>> getAllProducts() {
    return productsDatasourceRepo.getAllProducts();
  }

  // implementation
}
