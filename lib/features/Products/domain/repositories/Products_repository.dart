import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';

abstract class ProductsRepository {
  Future<Result<GetAllProductsEntity?>> getAllProducts();
}
