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
import '../../features/ManagerHome/data/datasources/ManagerHome_datasource_repo.dart'
    as _i650;
import '../../features/ManagerHome/data/datasources/ManagerHome_datasource_repo_impl.dart'
    as _i33;
import '../../features/ManagerHome/data/repositories_impl/ManagerHome_repo_impl.dart'
    as _i1029;
import '../../features/ManagerHome/domain/repositories/ManagerHome_repository.dart'
    as _i105;
import '../../features/ManagerHome/domain/useCases/ManagerHome_useCase_repo.dart'
    as _i794;
import '../../features/ManagerHome/domain/useCases/ManagerHome_useCase_repo_impl.dart'
    as _i260;
import '../../features/ManagerHome/presentation/bloc/ManagerHome_cubit.dart'
    as _i389;
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
import '../../features/Products/data/datasources/Products_datasource_repo.dart'
    as _i266;
import '../../features/Products/data/datasources/Products_datasource_repo_impl.dart'
    as _i760;
import '../../features/Products/data/repositories_impl/Products_repo_impl.dart'
    as _i724;
import '../../features/Products/domain/repositories/Products_repository.dart'
    as _i362;
import '../../features/Products/domain/useCases/Products_useCase_repo.dart'
    as _i1066;
import '../../features/Products/domain/useCases/Products_useCase_repo_impl.dart'
    as _i187;
import '../../features/Search/data/datasources/Search_datasource_repo.dart'
    as _i33;
import '../../features/Search/data/datasources/Search_datasource_repo_impl.dart'
    as _i786;
import '../../features/Search/data/repositories_impl/Search_repo_impl.dart'
    as _i901;
import '../../features/Search/domain/repositories/Search_repository.dart'
    as _i285;
import '../../features/Search/domain/useCases/Search_useCase_repo.dart'
    as _i293;
import '../../features/Search/domain/useCases/Search_useCase_repo_impl.dart'
    as _i339;
import '../../features/Search/presentation/bloc/Search_cubit.dart' as _i359;
import '../../features/Settings/data/datasources/Settings_datasource_repo.dart'
    as _i826;
import '../../features/Settings/data/datasources/Settings_datasource_repo_impl.dart'
    as _i625;
import '../../features/Settings/data/repositories_impl/Settings_repo_impl.dart'
    as _i583;
import '../../features/Settings/domain/repositories/Settings_repository.dart'
    as _i271;
import '../../features/Settings/domain/useCases/Settings_useCase_repo.dart'
    as _i650;
import '../../features/Settings/domain/useCases/Settings_useCase_repo_impl.dart'
    as _i502;
import '../../features/Settings/presentation/bloc/Settings_cubit.dart' as _i241;
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
    gh.factory<_i105.ManagerHomeRepository>(
      () => _i1029.ManagerHomeRepositoryImpl(),
    );
    gh.factory<_i271.SettingsRepository>(() => _i583.SettingsRepositoryImpl());
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i650.SettingsUseCaseRepo>(
      () => _i502.SettingsUseCase(gh<_i271.SettingsRepository>()),
    );
    gh.factory<_i972.ManagerScreenUseCaseRepo>(
      () => _i170.ManagerScreenUseCase(gh<_i627.ManagerScreenRepository>()),
    );
    gh.factory<_i266.ProductsDatasourceRepo>(
      () => _i760.ProductsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i33.SearchDatasourceRepo>(
      () => _i786.SearchDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i650.ManagerHomeDatasourceRepo>(
      () => _i33.ManagerHomeDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i423.ManagerScreenDatasourceRepo>(
      () => _i856.ManagerScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i354.AuthDatasourceRepo>(
      () => _i485.AuthDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i826.SettingsDatasourceRepo>(
      () => _i625.SettingsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1069.StoresDatasourceRepo>(
      () => _i133.StoresDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1051.ManagerScreenCubit>(
      () => _i1051.ManagerScreenCubit(gh<_i972.ManagerScreenUseCaseRepo>()),
    );
    gh.factory<_i794.ManagerHomeUseCaseRepo>(
      () => _i260.ManagerHomeUseCase(gh<_i105.ManagerHomeRepository>()),
    );
    gh.factory<_i285.SearchRepository>(
      () => _i901.SearchRepositoryImpl(gh<_i33.SearchDatasourceRepo>()),
    );
    gh.factory<_i241.SettingsCubit>(
      () => _i241.SettingsCubit(gh<_i650.SettingsUseCaseRepo>()),
    );
    gh.factory<_i647.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i354.AuthDatasourceRepo>()),
    );
    gh.factory<_i362.ProductsRepository>(
      () => _i724.ProductsRepositoryImpl(gh<_i266.ProductsDatasourceRepo>()),
    );
    gh.factory<_i628.AuthUseCaseRepo>(
      () => _i971.AuthUseCase(gh<_i647.AuthRepository>()),
    );
    gh.factory<_i592.StoresRepository>(
      () => _i49.StoresRepositoryImpl(gh<_i1069.StoresDatasourceRepo>()),
    );
    gh.factory<_i389.ManagerHomeCubit>(
      () => _i389.ManagerHomeCubit(gh<_i794.ManagerHomeUseCaseRepo>()),
    );
    gh.factory<_i293.SearchUseCaseRepo>(
      () => _i339.SearchUseCase(gh<_i285.SearchRepository>()),
    );
    gh.factory<_i192.AuthCubit>(
      () => _i192.AuthCubit(gh<_i628.AuthUseCaseRepo>()),
    );
    gh.factory<_i359.SearchCubit>(
      () => _i359.SearchCubit(gh<_i293.SearchUseCaseRepo>()),
    );
    gh.factory<_i1066.ProductsUseCaseRepo>(
      () => _i187.ProductsUseCase(gh<_i362.ProductsRepository>()),
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
