import 'ManagerScreen_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ManagerScreenDatasourceRepo)
class ManagerScreenDatasourceRepoImpl implements ManagerScreenDatasourceRepo {
  final ApiService apiService;
  ManagerScreenDatasourceRepoImpl(this.apiService);
}
