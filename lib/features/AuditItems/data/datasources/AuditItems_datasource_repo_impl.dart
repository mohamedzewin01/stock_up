import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/AuditItems/data/models/request/add_inventory_audit_items_request.dart';
import 'package:stock_up/features/AuditItems/data/models/request/search_audit_user_request.dart';
import 'package:stock_up/features/AuditItems/data/models/request/search_products_request.dart';
import 'package:stock_up/features/AuditItems/data/models/request/update_inventory_stem_status_request.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'AuditItems_datasource_repo.dart';

@Injectable(as: AuditItemsDatasourceRepo)
class AuditItemsDatasourceRepoImpl implements AuditItemsDatasourceRepo {
  final ApiService apiService;

  AuditItemsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddInventoryAuditItemsEntity?>> addInventoryAuditItems({
    String? notes,
    required int productId,
    required int quantity,
    required int auditId,
  }) {
    AddInventoryAuditItemsRequest addInventoryAuditItemsRequest =
        AddInventoryAuditItemsRequest(
          auditId: auditId,
          productId: productId,
          userId: CacheService.getData(key: CacheKeys.userId),
          quantity: quantity,
          notes: notes,
        );
    return executeApi(() async {
      final response = await apiService.addInventoryAuditItems(
        addInventoryAuditItemsRequest,
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<SearchProductsEntity?>> search(String? query, int? page) {
    SearchProductsRequest searchRequest = SearchProductsRequest(
      limit: 10,
      page: page ?? 1,
      q: query,
      storeId: CacheService.getData(key: CacheKeys.storeId) ?? 0,
    );
    return executeApi(() async {
      final result = await apiService.searchProducts(searchRequest);
      return result?.toEntity();
    });
  }

  @override
  Future<Result<UpdateInventoryStatusEntity?>> updateInventoryItemsStatus({
    required int auditId,
    required int itemId,
    required String status,
  }) {
    return executeApi(() async {
      final result = await apiService.updateInventoryItemStatus(
        UpdateInventoryStatusRequest(
          auditId: auditId,
          itemId: itemId,
          status: status,
        ),
      );
      return result?.toEntity();
    });
  }

  @override
  Future<Result<SearchAuditUserEntity?>> searchAuditUser() {
    return executeApi(() async {
      final result = await apiService.searchAuditUser(
        SearchAuditUserRequest(
          userId: CacheService.getData(key: CacheKeys.userId) ?? 0,
        ),
      );
      return result?.toEntity();
    });
  }
}
