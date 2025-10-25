import 'ManagerHome_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ManagerHomeDatasourceRepo)
class ManagerHomeDatasourceRepoImpl implements ManagerHomeDatasourceRepo {
  final ApiService apiService;
  ManagerHomeDatasourceRepoImpl(this.apiService);
}
