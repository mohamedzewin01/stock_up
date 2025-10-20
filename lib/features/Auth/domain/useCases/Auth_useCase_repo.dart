import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

abstract class AuthUseCaseRepo {
  Future<Result<LoginEntity?>> login(
    String mobileNumber,
    String password,
    int storeId,
  );
}
