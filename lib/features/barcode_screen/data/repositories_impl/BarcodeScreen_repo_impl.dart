import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';
import 'package:stock_up/features/barcode_screen/domain/repositories/BarcodeScreen_repository.dart';


@Injectable(as: BarcodeScreenRepository)
class BarcodeScreenRepositoryImpl
    implements BarcodeScreenRepository {
  final BarcodeScreenRepositoryImpl datasourceRepo;

  BarcodeScreenRepositoryImpl(this.datasourceRepo);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String storeId, String query) {
 return datasourceRepo.smartSearch(storeId, query);
  }




}
