import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';

abstract class EmployeeBarcodeScreenRepository {

  Future<Result<SmartSearchEntity?>> smartSearch(String query);
}
