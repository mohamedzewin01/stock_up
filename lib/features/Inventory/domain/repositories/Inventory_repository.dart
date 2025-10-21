import '../../../../core/common/api_result.dart';
import '../entities/inventory_entities.dart';

abstract class InventoryRepository {
  Future<Result<GetAllUsersEntity?>> getAllUsers();

  Future<Result<CreateInventoryAuditEntity?>> createInventoryAudit(
    String? notes,
  );

  Future<Result<GetInventoryByUserEntity?>> getInventoryByUser();

  Future<Result<AddInventoryAuditUsersEntity?>> addInventoryAuditUsers(
    List<int>? userIds,
  );

  Future<Result<UpdateAuditStatusEntity?>> updateAuditStatus({
    required int auditId,
  });
}
