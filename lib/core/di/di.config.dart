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

import '../../features/Auth/data/datasources/Auth_datasource_repo.dart'
    as _i354;
import '../../features/Auth/data/datasources/Auth_datasource_repo_impl.dart'
    as _i485;
import '../../features/Auth/data/repositories_impl/Auth_repo_impl.dart'
    as _i295;
import '../../features/Auth/domain/repositories/Auth_repository.dart' as _i647;
import '../../features/Auth/domain/useCases/Auth_useCase_repo.dart' as _i628;
import '../../features/Auth/domain/useCases/Auth_useCase_repo_impl.dart'
    as _i971;
import '../../features/Auth/presentation/bloc/Auth_cubit.dart' as _i192;
import '../../features/barcode_screen/data/datasources/BarcodeScreen_datasource_repo.dart'
    as _i4;
import '../../features/barcode_screen/data/datasources/BarcodeScreen_datasource_repo_impl.dart'
    as _i902;
import '../../features/barcode_screen/data/repositories_impl/BarcodeScreen_repo_impl.dart'
    as _i229;
import '../../features/barcode_screen/domain/repositories/BarcodeScreen_repository.dart'
    as _i707;
import '../../features/barcode_screen/domain/useCases/BarcodeScreen_useCase_repo.dart'
    as _i199;
import '../../features/barcode_screen/domain/useCases/BarcodeScreen_useCase_repo_impl.dart'
    as _i992;
import '../../features/barcode_screen/presentation/bloc/Barcode_cubit.dart'
    as _i132;
import '../../features/EmployeeScreen/data/datasources/EmployeeScreen_datasource_repo.dart'
    as _i42;
import '../../features/EmployeeScreen/data/datasources/EmployeeScreen_datasource_repo_impl.dart'
    as _i188;
import '../../features/EmployeeScreen/data/repositories_impl/EmployeeScreen_repo_impl.dart'
    as _i636;
import '../../features/EmployeeScreen/domain/repositories/EmployeeScreen_repository.dart'
    as _i93;
import '../../features/EmployeeScreen/domain/useCases/EmployeeScreen_useCase_repo.dart'
    as _i46;
import '../../features/EmployeeScreen/domain/useCases/EmployeeScreen_useCase_repo_impl.dart'
    as _i198;
import '../../features/EmployeeScreen/presentation/bloc/EmployeeScreen_cubit.dart'
    as _i303;
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
import '../../features/Stores/data/datasources/Stores_datasource_repo.dart'
    as _i1069;
import '../../features/Stores/data/datasources/Stores_datasource_repo_impl.dart'
    as _i133;
import '../../features/Stores/data/repositories_impl/Stores_repo_impl.dart'
    as _i49;
import '../../features/Stores/domain/repositories/Stores_repository.dart'
    as _i592;
import '../../features/Stores/domain/useCases/Stores_useCase_repo.dart'
    as _i795;
import '../../features/Stores/domain/useCases/Stores_useCase_repo_impl.dart'
    as _i1044;
import '../../features/Stores/presentation/bloc/Stores_cubit.dart' as _i1055;
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
    gh.factory<_i93.EmployeeScreenRepository>(
      () => _i636.EmployeeScreenRepositoryImpl(),
    );
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i707.BarcodeScreenRepository>(
      () => _i229.BarcodeScreenRepositoryImpl(
        gh<_i229.BarcodeScreenRepositoryImpl>(),
      ),
    );
    gh.factory<_i46.EmployeeScreenUseCaseRepo>(
      () => _i198.EmployeeScreenUseCase(gh<_i93.EmployeeScreenRepository>()),
    );
    gh.factory<_i972.ManagerScreenUseCaseRepo>(
      () => _i170.ManagerScreenUseCase(gh<_i627.ManagerScreenRepository>()),
    );
    gh.factory<_i423.ManagerScreenDatasourceRepo>(
      () => _i856.ManagerScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i354.AuthDatasourceRepo>(
      () => _i485.AuthDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1069.StoresDatasourceRepo>(
      () => _i133.StoresDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i42.EmployeeScreenDatasourceRepo>(
      () => _i188.EmployeeScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i4.BarcodeScreenDatasourceRepo>(
      () => _i902.BarcodeScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1051.ManagerScreenCubit>(
      () => _i1051.ManagerScreenCubit(gh<_i972.ManagerScreenUseCaseRepo>()),
    );
    gh.factory<_i199.BarcodeScreenUseCaseRepo>(
      () => _i992.BarcodeScreenUseCase(gh<_i707.BarcodeScreenRepository>()),
    );
    gh.factory<_i303.EmployeeScreenCubit>(
      () => _i303.EmployeeScreenCubit(gh<_i46.EmployeeScreenUseCaseRepo>()),
    );
    gh.factory<_i647.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i354.AuthDatasourceRepo>()),
    );
    gh.factory<_i132.BarcodeCubit>(
      () => _i132.BarcodeCubit(gh<_i199.BarcodeScreenUseCaseRepo>()),
    );
    gh.factory<_i628.AuthUseCaseRepo>(
      () => _i971.AuthUseCase(gh<_i647.AuthRepository>()),
    );
    gh.factory<_i592.StoresRepository>(
      () => _i49.StoresRepositoryImpl(gh<_i1069.StoresDatasourceRepo>()),
    );
    gh.factory<_i192.AuthCubit>(
      () => _i192.AuthCubit(gh<_i628.AuthUseCaseRepo>()),
    );
    gh.factory<_i795.StoresUseCaseRepo>(
      () => _i1044.StoresUseCase(gh<_i592.StoresRepository>()),
    );
    gh.factory<_i1055.StoresCubit>(
      () => _i1055.StoresCubit(gh<_i795.StoresUseCaseRepo>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
