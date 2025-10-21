import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/AuditItems/data/datasources/AuditItems_datasource_repo.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

import '../../domain/repositories/AuditItems_repository.dart';

@Injectable(as: AuditItemsRepository)
class AuditItemsRepositoryImpl implements AuditItemsRepository {
  final AuditItemsDatasourceRepo auditItemsDatasourceRepo;

  AuditItemsRepositoryImpl(this.auditItemsDatasourceRepo);

  @override
  Future<Result<AddInventoryAuditItemsEntity?>> addInventoryAuditItems({
    String? notes,
    required int productId,
    required int quantity,
  }) {
    return auditItemsDatasourceRepo.addInventoryAuditItems(
      notes: notes,
      productId: productId,
      quantity: quantity,
    );
  }

  @override
  Future<Result<SearchProductsEntity?>> search(String? query, int? page) {
    return auditItemsDatasourceRepo.search(query, page);
  }
}
