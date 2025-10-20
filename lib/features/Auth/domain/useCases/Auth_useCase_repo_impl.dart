import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

import '../repositories/Auth_repository.dart';
import '../useCases/Auth_useCase_repo.dart';

@Injectable(as: AuthUseCaseRepo)
class AuthUseCase implements AuthUseCaseRepo {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  @override
  Future<Result<LoginEntity?>> login(
    String mobileNumber,
    String password,
    int storeId,
  ) {
    return repository.login(
      LoginRequest(
        mobileNumber: mobileNumber,
        password: password,
        storeId: storeId,
      ),
    );
  }
}
