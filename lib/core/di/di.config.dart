// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/EmployeeBarcodeScreen/data/datasources/EmployeeBarcodeScreen_datasource_repo.dart'
    as _i524;
import '../../features/EmployeeBarcodeScreen/data/datasources/EmployeeBarcodeScreen_datasource_repo_impl.dart'
    as _i656;
import '../../features/EmployeeBarcodeScreen/data/repositories_impl/EmployeeBarcodeScreen_repo_impl.dart'
    as _i1016;
import '../../features/EmployeeBarcodeScreen/domain/repositories/EmployeeBarcodeScreen_repository.dart'
    as _i521;
import '../../features/EmployeeBarcodeScreen/domain/useCases/EmployeeBarcodeScreen_useCase_repo.dart'
    as _i8;
import '../../features/EmployeeBarcodeScreen/domain/useCases/EmployeeBarcodeScreen_useCase_repo_impl.dart'
    as _i677;
import '../../features/EmployeeBarcodeScreen/presentation/bloc/EmployeeBarcodeScreen_cubit.dart'
    as _i143;
import '../../features/ManagerScreen/data/datasources/ManagerScreen_datasource_repo.dart'
    as _i423;
import '../../features/ManagerScreen/data/datasources/ManagerScreen_datasource_repo_impl.dart'
    as _i856;
import '../../features/ManagerScreen/data/repositories_impl/ManagerScreen_repo_impl.dart'
    as _i806;
import '../../features/ManagerScreen/domain/repositories/ManagerScreen_repository.dart'
    as _i627;
import '../../features/ManagerScreen/domain/useCases/ManagerScreen_useCase_repo.dart'
    as _i972;
import '../../features/ManagerScreen/domain/useCases/ManagerScreen_useCase_repo_impl.dart'
    as _i170;
import '../../features/ManagerScreen/presentation/bloc/ManagerScreen_cubit.dart'
    as _i1051;
import '../api/api_manager/api_manager.dart' as _i680;
import '../api/dio_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.providerDio());
    gh.factory<_i627.ManagerScreenRepository>(
      () => _i806.ManagerScreenRepositoryImpl(),
    );
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i972.ManagerScreenUseCaseRepo>(
      () => _i170.ManagerScreenUseCase(gh<_i627.ManagerScreenRepository>()),
    );
    gh.factory<_i423.ManagerScreenDatasourceRepo>(
      () => _i856.ManagerScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i524.EmployeeBarcodeScreenDatasourceRepo>(
      () =>
          _i656.EmployeeBarcodeScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1051.ManagerScreenCubit>(
      () => _i1051.ManagerScreenCubit(gh<_i972.ManagerScreenUseCaseRepo>()),
    );
    gh.factory<_i521.EmployeeBarcodeScreenRepository>(
      () => _i1016.EmployeeBarcodeScreenRepositoryImpl(
        gh<_i524.EmployeeBarcodeScreenDatasourceRepo>(),
      ),
    );
    gh.factory<_i8.EmployeeBarcodeScreenUseCaseRepo>(
      () => _i677.EmployeeBarcodeScreenUseCase(
        gh<_i521.EmployeeBarcodeScreenRepository>(),
      ),
    );
    gh.factory<_i143.EmployeeBarcodeScreenCubit>(
      () => _i143.EmployeeBarcodeScreenCubit(
        gh<_i8.EmployeeBarcodeScreenUseCaseRepo>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
