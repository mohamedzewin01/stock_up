import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Auth/data/datasources/Auth_datasource_repo.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

import '../../domain/repositories/Auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasourceRepo authDatasourceRepo;

  AuthRepositoryImpl(this.authDatasourceRepo);

  @override
  Future<Result<LoginEntity?>> login(LoginRequest loginRequest) {
    return authDatasourceRepo.login(loginRequest);
  }
}
