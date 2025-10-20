import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/data/datasources/Inventory_datasource_repo.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

import '../../domain/repositories/Inventory_repository.dart';

@Injectable(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDatasourceRepo inventoryDatasourceRepo;

  InventoryRepositoryImpl(this.inventoryDatasourceRepo);

  @override
  Future<Result<GetAllUsersEntity?>> getAllUsers() {
    return inventoryDatasourceRepo.getAllUsers();
  }

  @override
  Future<Result<AddInventoryAuditUsersEntity?>> addInventoryAuditUsers(
    List<int>? userIds,
  ) {
    return inventoryDatasourceRepo.addInventoryAuditUsers(userIds);
  }

  @override
  Future<Result<CreateInventoryAuditEntity?>> createInventoryAudit(
    String? notes,
  ) {
    return inventoryDatasourceRepo.createInventoryAudit(notes);
  }

  @override
  Future<Result<GetInventoryByUserEntity?>> getInventoryByUser() {
    return inventoryDatasourceRepo.getInventoryByUser();
  }
}
