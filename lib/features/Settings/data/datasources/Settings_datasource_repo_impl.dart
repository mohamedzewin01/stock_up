import 'Settings_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: SettingsDatasourceRepo)
class SettingsDatasourceRepoImpl implements SettingsDatasourceRepo {
  final ApiService apiService;
  SettingsDatasourceRepoImpl(this.apiService);
}
