import 'POSPage_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: POSPageDatasourceRepo)
class POSPageDatasourceRepoImpl implements POSPageDatasourceRepo {
  final ApiService apiService;
  POSPageDatasourceRepoImpl(this.apiService);
}
