import 'package:stock_up/features/Inventory/data/models/response/smart_search_Model.dart';

class SmartSearchEntity {
  final String? status;

  final Store? store;

  final List<Results>? results;

  SmartSearchEntity({this.status, this.store, this.results});
}
