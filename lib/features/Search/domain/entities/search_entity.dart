import '../../data/models/response/search_model.dart';

class SearchEntity {
  final String? status;

  final Store? store;

  final int? page;

  final int? limit;

  final int? totalItems;

  final int? totalPages;

  final List<Results>? results;

  SearchEntity({
    this.status,
    this.store,
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.results,
  });
}
