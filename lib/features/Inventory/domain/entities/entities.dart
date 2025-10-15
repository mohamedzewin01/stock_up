import 'package:stock_up/features/Inventory/data/models/response/smart_search_Model.dart';

class SearchEntity {
  final String? status;

  final Store? store;

  final List<Results>? results;

  SearchEntity({this.status, this.store, this.results});
}
