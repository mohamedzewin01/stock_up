import 'EmployeeBarcodeScreen_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: EmployeeBarcodeScreenDatasourceRepo)
class EmployeeBarcodeScreenDatasourceRepoImpl implements EmployeeBarcodeScreenDatasourceRepo {
  final ApiService apiService;
  EmployeeBarcodeScreenDatasourceRepoImpl(this.apiService);
}
