import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Inventory/domain/entities/inventory_entities.dart';

import '../repositories/Inventory_repository.dart';
import '../useCases/Inventory_useCase_repo.dart';

@Injectable(as: InventoryUseCaseRepo)
class InventoryUseCase implements InventoryUseCaseRepo {
  final InventoryRepository repository;

  InventoryUseCase(this.repository);

  @override
  Future<Result<GetAllUsersEntity?>> getAllUsers() {
    return repository.getAllUsers();
  }

  @override
  Future<Result<AddInventoryAuditUsersEntity?>> addInventoryAuditUsers(
    List<int>? userIds,
  ) {
    return repository.addInventoryAuditUsers(userIds);
  }

  @override
  Future<Result<CreateInventoryAuditEntity?>> createInventoryAudit(
    String? notes,
  ) {
    return repository.createInventoryAudit(notes);
  }

  @override
  Future<Result<GetInventoryByUserEntity?>> getInventoryByUser() {
    return repository.getInventoryByUser();
  }

  @override
  Future<Result<UpdateAuditStatusEntity?>> updateAuditStatus({
    required int auditId,
  }) {
    return repository.updateAuditStatus(auditId: auditId);
  }
}
