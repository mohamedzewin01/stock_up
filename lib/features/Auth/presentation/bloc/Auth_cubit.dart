import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Auth/domain/entities/login_entity.dart';

import '../../domain/useCases/Auth_useCase_repo.dart';

part 'Auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authUseCaseRepo) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool rememberMe = false;
  String storeName = '';

  void handleRememberMe(bool newValue) {
    rememberMe = !rememberMe;
    emit(AuthInitial());
  }

  void handleStoreName(String newValue) {
    storeName = newValue;
    emit(AuthInitial());
  }

  final AuthUseCaseRepo _authUseCaseRepo;

  Future<void> login(String mobileNumber, String password, int storeId) async {
    emit(AuthLoading());
    final result = await _authUseCaseRepo.login(
      mobileNumber,
      password,
      storeId,
    );
    switch (result) {
      case Success<LoginEntity?>():
        CacheService.setData(
          key: CacheKeys.userId,
          value: result.data?.user?.id,
        );
        CacheService.setData(
          key: CacheKeys.userName,
          value:
              '${result.data?.user?.firstName} ${result.data?.user?.lastName}',
        );
        CacheService.setData(
          key: CacheKeys.userPhone,
          value: result.data?.user?.phoneNumber,
        );
        CacheService.setData(
          key: CacheKeys.userRole,
          value: result.data?.user?.role,
        );
        CacheService.setData(
          key: CacheKeys.profileImage,
          value: result.data?.user?.profileImage,
        );
        CacheService.setData(
          key: CacheKeys.storeId,
          value: result.data?.store?.id,
        );
        CacheService.setData(
          key: CacheKeys.storeName,
          value: result.data?.store?.storeName,
        );
        CacheService.setData(key: CacheKeys.rememberMe, value: rememberMe);
        emit(AuthSuccess(result.data));
        break;
      case Fail<LoginEntity?>():
        emit(AuthFailure(result.exception));
        break;
    }
  }
}
