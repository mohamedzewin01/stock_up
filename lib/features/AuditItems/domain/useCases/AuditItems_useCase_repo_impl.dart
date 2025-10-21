import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

import '../repositories/AuditItems_repository.dart';
import '../useCases/AuditItems_useCase_repo.dart';

@Injectable(as: AuditItemsUseCaseRepo)
class AuditItemsUseCase implements AuditItemsUseCaseRepo {
  final AuditItemsRepository repository;

  AuditItemsUseCase(this.repository);

  @override
  Future<Result<AddInventoryAuditItemsEntity?>> addInventoryAuditItems({
    String? notes,
    required int productId,
    required int quantity,
    required int auditId,
  }) {
    return repository.addInventoryAuditItems(
      notes: notes,
      productId: productId,
      quantity: quantity,
      auditId: auditId,
    );
  }

  @override
  Future<Result<SearchProductsEntity?>> search(String? query, int? page) {
    return repository.search(query, page);
  }

  @override
  Future<Result<UpdateInventoryStatusEntity?>> updateInventoryItemsStatus({
    required int auditId,
    required int itemId,
    required String status,
  }) {
    return repository.updateInventoryItemsStatus(
      auditId: auditId,
      itemId: itemId,
      status: status,
    );
  }

  @override
  Future<Result<SearchAuditUserEntity?>> searchAuditUser() {
    return repository.searchAuditUser();
  }
}
