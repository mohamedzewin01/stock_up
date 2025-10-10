
import 'package:stock_up/features/EmployeeBarcodeScreen/data/models/response/smart_search_Model.dart';

class SmartSearchEntity {
  final String? status;

  final String? source;

  final List<Results>? results;

  SmartSearchEntity({this.status, this.source, this.results});
}
