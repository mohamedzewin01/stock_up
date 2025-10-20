import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity?>> login(LoginRequest loginRequest);
}
