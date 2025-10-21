import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

abstract class AuditItemsDatasourceRepo {
  Future<Result<AddInventoryAuditItemsEntity?>> addInventoryAuditItems({
    String? notes,
    required int productId,
    required int quantity,
  });

  Future<Result<SearchProductsEntity?>> search(String? query, int? page);

  Future<Result<UpdateInventoryStatusEntity?>> updateInventoryItemsStatus({
    required int auditId,
    required int itemId,
    required String status,
  });
}
