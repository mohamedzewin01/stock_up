import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';
import 'package:stock_up/features/barcode_screen/domain/repositories/BarcodeScreen_repository.dart';
import 'package:injectable/injectable.dart';
import 'BarcodeScreen_useCase_repo.dart';

@Injectable(as: BarcodeScreenUseCaseRepo)
class BarcodeScreenUseCase implements BarcodeScreenUseCaseRepo {
  final BarcodeScreenRepository repository;

  BarcodeScreenUseCase(this.repository);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String storeId, String query) {
   return repository.smartSearch(storeId, query);
  }




}
