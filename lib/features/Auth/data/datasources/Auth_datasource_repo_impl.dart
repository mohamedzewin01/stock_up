import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Auth_datasource_repo.dart';

@Injectable(as: AuthDatasourceRepo)
class AuthDatasourceRepoImpl implements AuthDatasourceRepo {
  final ApiService apiService;

  AuthDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<LoginEntity?>> login(LoginRequest loginRequest) {
    return executeApi(() async {
      final result = await apiService.login(loginRequest);
      return result?.toEntity();
    });
  }
}
