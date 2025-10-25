import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Inventory/data/models/request/add_inventory_audit_users_request.dart';
import 'package:stock_up/features/Inventory/data/models/request/create_inventory_audit_request.dart';
import 'package:stock_up/features/Inventory/data/models/request/get_inventory_by_user_request.dart';
import 'package:stock_up/features/Inventory/data/models/request/update_audit_status_request.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Inventory_datasource_repo.dart';

@Injectable(as: InventoryDatasourceRepo)
class InventoryDatasourceRepoImpl implements InventoryDatasourceRepo {
  final ApiService apiService;

  InventoryDatasourceRepoImpl(this.apiService);

  final userId = CacheService.getData(key: CacheKeys.userId) ?? 0;
  final storeId = CacheService.getData(key: CacheKeys.storeId) ?? 0;

  @override
  Future<Result<GetAllUsersEntity?>> getAllUsers() {
    return executeApi(() async {
      final response = await apiService.getAllUsers();
      return response?.toEntity();
    });
  }

  @override
  Future<Result<AddInventoryAuditUsersEntity?>> addInventoryAuditUsers(
    List<int>? userIds,
  ) {
    return executeApi(() async {
      final auditId = CacheService.getData(key: CacheKeys.auditId) ?? 0;
      AddInventoryAuditUsersRequest addInventoryAuditUsersRequest =
          AddInventoryAuditUsersRequest(auditId: auditId, userIds: userIds);
      final response = await apiService.addInventoryAuditUsers(
        addInventoryAuditUsersRequest,
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<CreateInventoryAuditEntity?>> createInventoryAudit(
    String? notes,
  ) {
    return executeApi(() async {
      CreateInventoryAuditRequest createInventoryAuditRequest =
          CreateInventoryAuditRequest(
            creatorUserId: userId,
            storeId: storeId,
            notes: notes,
          );
      final response = await apiService.createInventoryAudit(
        createInventoryAuditRequest,
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<GetInventoryByUserEntity?>> getInventoryByUser() {
    return executeApi(() async {
      GetInventoryByUserRequest getInventoryByUserRequest =
          GetInventoryByUserRequest(creatorUserId: userId, storeId: storeId);
      final response = await apiService.getInventoryByUser(
        getInventoryByUserRequest,
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<UpdateAuditStatusEntity?>> updateAuditStatus({
    required int auditId,
  }) {
    return executeApi(() async {
      final result = await apiService.updateAuditStatus(
        UpdateAuditStatusRequest(auditId: auditId, creatorUserId: userId),
      );
      return result?.toEntity();
    });
  }
}
