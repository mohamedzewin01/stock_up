import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/data/datasources/EmployeeBarcodeScreen_datasource_repo.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';
import '../../domain/repositories/EmployeeBarcodeScreen_repository.dart';

@Injectable(as: EmployeeBarcodeScreenRepository)
class EmployeeBarcodeScreenRepositoryImpl
    implements EmployeeBarcodeScreenRepository {
  final EmployeeBarcodeScreenDatasourceRepo datasourceRepo;

  EmployeeBarcodeScreenRepositoryImpl(this.datasourceRepo);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String query) {
    return datasourceRepo.smartSearch(query);
  }


}
