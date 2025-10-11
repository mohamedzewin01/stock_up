import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';

abstract class BarcodeScreenUseCaseRepo {
  Future<Result<SmartSearchEntity?>> smartSearch( String storeId,String query);
}
