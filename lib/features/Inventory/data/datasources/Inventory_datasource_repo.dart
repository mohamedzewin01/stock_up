import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

abstract class InventoryDatasourceRepo {
  Future<Result<GetAllUsersEntity?>> getAllUsers();

  Future<Result<CreateInventoryAuditEntity?>> createInventoryAudit(
    String? notes,
  );

  Future<Result<GetInventoryByUserEntity?>> getInventoryByUser();

  Future<Result<AddInventoryAuditUsersEntity?>> addInventoryAuditUsers(
    List<int>? userIds,
  );
}
