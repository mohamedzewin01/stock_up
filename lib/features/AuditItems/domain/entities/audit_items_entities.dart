import '../../data/models/response/search_products_model.dart';

class AddInventoryAuditItemsEntity {
  final String? status;

  final String? message;

  final int? version;

  final String? createdAt;

  AddInventoryAuditItemsEntity({
    this.status,
    this.message,
    this.version,
    this.createdAt,
  });
}

class SearchProductsEntity {
  final String? status;

  final Store? store;

  final int? page;

  final int? limit;

  final int? totalItems;

  final int? totalPages;

  final List<Results>? results;

  SearchProductsEntity({
    this.status,
    this.store,
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.results,
  });
}

class UpdateAuditStatusEntity {
  final String? status;

  final String? message;

  final int? auditId;

  final String? newStatus;

  final int? pendingItemsCount;

  UpdateAuditStatusEntity({
    this.status,
    this.message,
    this.auditId,
    this.newStatus,
    this.pendingItemsCount,
  });
}
