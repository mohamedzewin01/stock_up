import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Products/data/models/request/get_all_products_request.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Products_datasource_repo.dart';

@Injectable(as: ProductsDatasourceRepo)
class ProductsDatasourceRepoImpl implements ProductsDatasourceRepo {
  final ApiService apiService;

  ProductsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetAllProductsEntity?>> getAllProducts() {
    return executeApi(() async {
      String storeId ="2";
         // CacheService.getData(key: CacheKeys.storeId) ?? '0';

      final response = await apiService.getAllProducts(
        GetAllProductsRequest(storeId: storeId),
      );
      return response?.toEntity();
    });
  }
}
