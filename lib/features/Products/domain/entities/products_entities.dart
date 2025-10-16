import '../../data/models/response/get_all_products_model.dart';

class GetAllProductsEntity {
  final String? status;

  final Store? store;

  final int? totalItems;

  final List<Results>? results;

  GetAllProductsEntity({
    this.status,
    this.store,
    this.totalItems,
    this.results,
  });
}
