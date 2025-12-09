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

import '../../features/AuditItems/data/datasources/AuditItems_datasource_repo.dart'
    as _i257;
import '../../features/AuditItems/data/datasources/AuditItems_datasource_repo_impl.dart'
    as _i237;
import '../../features/AuditItems/data/repositories_impl/AuditItems_repo_impl.dart'
    as _i308;
import '../../features/AuditItems/domain/repositories/AuditItems_repository.dart'
    as _i291;
import '../../features/AuditItems/domain/useCases/AuditItems_useCase_repo.dart'
    as _i183;
import '../../features/AuditItems/domain/useCases/AuditItems_useCase_repo_impl.dart'
    as _i56;
import '../../features/AuditItems/presentation/bloc/AuditItems_cubit.dart'
    as _i274;
import '../../features/AuditItems/presentation/bloc/search_audit_user/search_audit_user_cubit.dart'
    as _i891;
import '../../features/AuditItems/presentation/bloc/SearchProducts/search_products_cubit.dart'
    as _i613;
import '../../features/AuditItems/presentation/bloc/update_inventory_items_status/update_items_status_cubit.dart'
    as _i102;
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
import '../../features/Barcodes/data/datasources/Barcodes_datasource_repo.dart'
    as _i1031;
import '../../features/Barcodes/data/datasources/Barcodes_datasource_repo_impl.dart'
    as _i173;
import '../../features/Barcodes/data/repositories_impl/Barcodes_repo_impl.dart'
    as _i241;
import '../../features/Barcodes/domain/repositories/Barcodes_repository.dart'
    as _i230;
import '../../features/Barcodes/domain/useCases/Barcodes_useCase_repo.dart'
    as _i705;
import '../../features/Barcodes/domain/useCases/Barcodes_useCase_repo_impl.dart'
    as _i560;
import '../../features/Barcodes/presentation/bloc/Barcodes_cubit.dart' as _i398;
import '../../features/Home/data/datasources/ManagerHome_datasource_repo.dart'
    as _i983;
import '../../features/Home/data/datasources/ManagerHome_datasource_repo_impl.dart'
    as _i800;
import '../../features/Home/data/repositories_impl/ManagerHome_repo_impl.dart'
    as _i902;
import '../../features/Home/domain/repositories/ManagerHome_repository.dart'
    as _i378;
import '../../features/Home/domain/useCases/ManagerHome_useCase_repo.dart'
    as _i478;
import '../../features/Home/domain/useCases/ManagerHome_useCase_repo_impl.dart'
    as _i724;
import '../../features/Home/presentation/bloc/ManagerHome_cubit.dart' as _i632;
import '../../features/Inventory/data/datasources/Inventory_datasource_repo.dart'
    as _i180;
import '../../features/Inventory/data/datasources/Inventory_datasource_repo_impl.dart'
    as _i413;
import '../../features/Inventory/data/repositories_impl/Inventory_repo_impl.dart'
    as _i629;
import '../../features/Inventory/domain/repositories/Inventory_repository.dart'
    as _i675;
import '../../features/Inventory/domain/useCases/Inventory_useCase_repo.dart'
    as _i1018;
import '../../features/Inventory/domain/useCases/Inventory_useCase_repo_impl.dart'
    as _i449;
import '../../features/Inventory/presentation/bloc/AddInventory/add_inventory_cubit.dart'
    as _i421;
import '../../features/Inventory/presentation/bloc/createInventory/create_inventory_cubit.dart'
    as _i678;
import '../../features/Inventory/presentation/bloc/InventoryByUser/inventory_user_cubit.dart'
    as _i214;
import '../../features/Inventory/presentation/bloc/update_audit_status/update_audit_status_cubit.dart'
    as _i359;
import '../../features/Inventory/presentation/bloc/users/users_inventory_cubit.dart'
    as _i821;
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
import '../../features/POSPage/data/datasources/POSPage_datasource_repo.dart'
    as _i830;
import '../../features/POSPage/data/datasources/POSPage_datasource_repo_impl.dart'
    as _i448;
import '../../features/POSPage/data/repositories_impl/POSPage_repo_impl.dart'
    as _i228;
import '../../features/POSPage/domain/repositories/POSPage_repository.dart'
    as _i230;
import '../../features/POSPage/domain/useCases/POSPage_useCase_repo.dart'
    as _i381;
import '../../features/POSPage/domain/useCases/POSPage_useCase_repo_impl.dart'
    as _i660;
import '../../features/POSPage/presentation/bloc/POSPage_cubit.dart' as _i647;
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
import '../../features/Shift/data/datasources/Shift_datasource_repo.dart'
    as _i933;
import '../../features/Shift/data/datasources/Shift_datasource_repo_impl.dart'
    as _i886;
import '../../features/Shift/data/repositories_impl/Shift_repo_impl.dart'
    as _i190;
import '../../features/Shift/domain/repositories/Shift_repository.dart'
    as _i251;
import '../../features/Shift/domain/useCases/Shift_useCase_repo.dart' as _i119;
import '../../features/Shift/domain/useCases/Shift_useCase_repo_impl.dart'
    as _i802;
import '../../features/Shift/presentation/bloc/closed_shift/closed_shifts_cubit.dart'
    as _i887;
import '../../features/Shift/presentation/bloc/open_shift/open_shift_cubit.dart'
    as _i773;
import '../../features/Shift/presentation/bloc/Shift_cubit.dart' as _i722;
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
import '../../features/Summary/data/datasources/Summary_datasource_repo.dart'
    as _i563;
import '../../features/Summary/data/datasources/Summary_datasource_repo_impl.dart'
    as _i996;
import '../../features/Summary/data/repositories_impl/Summary_repo_impl.dart'
    as _i281;
import '../../features/Summary/domain/repositories/Summary_repository.dart'
    as _i178;
import '../../features/Summary/domain/useCases/Summary_useCase_repo.dart'
    as _i656;
import '../../features/Summary/domain/useCases/Summary_useCase_repo_impl.dart'
    as _i104;
import '../../features/Summary/presentation/bloc/Summary_cubit.dart' as _i246;
import '../../features/Transaction/data/datasources/Transaction_datasource_repo.dart'
    as _i162;
import '../../features/Transaction/data/datasources/Transaction_datasource_repo_impl.dart'
    as _i4;
import '../../features/Transaction/data/repositories_impl/Transaction_repo_impl.dart'
    as _i515;
import '../../features/Transaction/domain/repositories/Transaction_repository.dart'
    as _i148;
import '../../features/Transaction/domain/useCases/Transaction_useCase_repo.dart'
    as _i15;
import '../../features/Transaction/domain/useCases/Transaction_useCase_repo_impl.dart'
    as _i657;
import '../../features/Transaction/presentation/bloc/Transaction_cubit.dart'
    as _i321;
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
    gh.factory<_i230.POSPageRepository>(() => _i228.POSPageRepositoryImpl());
    gh.factory<_i378.ManagerHomeRepository>(
      () => _i902.ManagerHomeRepositoryImpl(),
    );
    gh.factory<_i271.SettingsRepository>(() => _i583.SettingsRepositoryImpl());
    gh.factory<_i680.ApiService>(() => _i680.ApiService(gh<_i361.Dio>()));
    gh.factory<_i650.SettingsUseCaseRepo>(
      () => _i502.SettingsUseCase(gh<_i271.SettingsRepository>()),
    );
    gh.factory<_i972.ManagerScreenUseCaseRepo>(
      () => _i170.ManagerScreenUseCase(gh<_i627.ManagerScreenRepository>()),
    );
    gh.factory<_i180.InventoryDatasourceRepo>(
      () => _i413.InventoryDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i381.POSPageUseCaseRepo>(
      () => _i660.POSPageUseCase(gh<_i230.POSPageRepository>()),
    );
    gh.factory<_i33.SearchDatasourceRepo>(
      () => _i786.SearchDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i423.ManagerScreenDatasourceRepo>(
      () => _i856.ManagerScreenDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i354.AuthDatasourceRepo>(
      () => _i485.AuthDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i563.SummaryDatasourceRepo>(
      () => _i996.SummaryDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i162.TransactionDatasourceRepo>(
      () => _i4.TransactionDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1031.BarcodesDatasourceRepo>(
      () => _i173.BarcodesDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i826.SettingsDatasourceRepo>(
      () => _i625.SettingsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i1069.StoresDatasourceRepo>(
      () => _i133.StoresDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i230.BarcodesRepository>(
      () => _i241.BarcodesRepositoryImpl(gh<_i1031.BarcodesDatasourceRepo>()),
    );
    gh.factory<_i705.BarcodesUseCaseRepo>(
      () => _i560.BarcodesUseCase(gh<_i230.BarcodesRepository>()),
    );
    gh.factory<_i983.ManagerHomeDatasourceRepo>(
      () => _i800.ManagerHomeDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i398.BarcodesCubit>(
      () => _i398.BarcodesCubit(gh<_i705.BarcodesUseCaseRepo>()),
    );
    gh.factory<_i830.POSPageDatasourceRepo>(
      () => _i448.POSPageDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i933.ShiftDatasourceRepo>(
      () => _i886.ShiftDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i251.ShiftRepository>(
      () => _i190.ShiftRepositoryImpl(gh<_i933.ShiftDatasourceRepo>()),
    );
    gh.factory<_i1051.ManagerScreenCubit>(
      () => _i1051.ManagerScreenCubit(gh<_i972.ManagerScreenUseCaseRepo>()),
    );
    gh.factory<_i257.AuditItemsDatasourceRepo>(
      () => _i237.AuditItemsDatasourceRepoImpl(gh<_i680.ApiService>()),
    );
    gh.factory<_i178.SummaryRepository>(
      () => _i281.SummaryRepositoryImpl(gh<_i563.SummaryDatasourceRepo>()),
    );
    gh.factory<_i285.SearchRepository>(
      () => _i901.SearchRepositoryImpl(gh<_i33.SearchDatasourceRepo>()),
    );
    gh.factory<_i241.SettingsCubit>(
      () => _i241.SettingsCubit(gh<_i650.SettingsUseCaseRepo>()),
    );
    gh.factory<_i647.POSPageCubit>(
      () => _i647.POSPageCubit(gh<_i381.POSPageUseCaseRepo>()),
    );
    gh.factory<_i148.TransactionRepository>(
      () => _i515.TransactionRepositoryImpl(
        gh<_i162.TransactionDatasourceRepo>(),
      ),
    );
    gh.factory<_i647.AuthRepository>(
      () => _i295.AuthRepositoryImpl(gh<_i354.AuthDatasourceRepo>()),
    );
    gh.factory<_i478.ManagerHomeUseCaseRepo>(
      () => _i724.ManagerHomeUseCase(gh<_i378.ManagerHomeRepository>()),
    );
    gh.factory<_i656.SummaryUseCaseRepo>(
      () => _i104.SummaryUseCase(gh<_i178.SummaryRepository>()),
    );
    gh.factory<_i675.InventoryRepository>(
      () => _i629.InventoryRepositoryImpl(gh<_i180.InventoryDatasourceRepo>()),
    );
    gh.factory<_i15.TransactionUseCaseRepo>(
      () => _i657.TransactionUseCase(gh<_i148.TransactionRepository>()),
    );
    gh.factory<_i119.ShiftUseCaseRepo>(
      () => _i802.ShiftUseCase(gh<_i251.ShiftRepository>()),
    );
    gh.factory<_i628.AuthUseCaseRepo>(
      () => _i971.AuthUseCase(gh<_i647.AuthRepository>()),
    );
    gh.factory<_i291.AuditItemsRepository>(
      () =>
          _i308.AuditItemsRepositoryImpl(gh<_i257.AuditItemsDatasourceRepo>()),
    );
    gh.factory<_i592.StoresRepository>(
      () => _i49.StoresRepositoryImpl(gh<_i1069.StoresDatasourceRepo>()),
    );
    gh.factory<_i321.TransactionCubit>(
      () => _i321.TransactionCubit(gh<_i15.TransactionUseCaseRepo>()),
    );
    gh.factory<_i246.SummaryCubit>(
      () => _i246.SummaryCubit(gh<_i656.SummaryUseCaseRepo>()),
    );
    gh.factory<_i293.SearchUseCaseRepo>(
      () => _i339.SearchUseCase(gh<_i285.SearchRepository>()),
    );
    gh.factory<_i192.AuthCubit>(
      () => _i192.AuthCubit(gh<_i628.AuthUseCaseRepo>()),
    );
    gh.factory<_i632.ManagerHomeCubit>(
      () => _i632.ManagerHomeCubit(gh<_i478.ManagerHomeUseCaseRepo>()),
    );
    gh.factory<_i359.SearchCubit>(
      () => _i359.SearchCubit(gh<_i293.SearchUseCaseRepo>()),
    );
    gh.factory<_i1018.InventoryUseCaseRepo>(
      () => _i449.InventoryUseCase(gh<_i675.InventoryRepository>()),
    );
    gh.factory<_i421.AddInventoryCubit>(
      () => _i421.AddInventoryCubit(gh<_i1018.InventoryUseCaseRepo>()),
    );
    gh.factory<_i678.CreateInventoryCubit>(
      () => _i678.CreateInventoryCubit(gh<_i1018.InventoryUseCaseRepo>()),
    );
    gh.factory<_i214.InventoryUserCubit>(
      () => _i214.InventoryUserCubit(gh<_i1018.InventoryUseCaseRepo>()),
    );
    gh.factory<_i359.UpdateAuditStatusCubit>(
      () => _i359.UpdateAuditStatusCubit(gh<_i1018.InventoryUseCaseRepo>()),
    );
    gh.factory<_i821.UsersInventoryCubit>(
      () => _i821.UsersInventoryCubit(gh<_i1018.InventoryUseCaseRepo>()),
    );
    gh.factory<_i887.ClosedShiftsCubit>(
      () => _i887.ClosedShiftsCubit(gh<_i119.ShiftUseCaseRepo>()),
    );
    gh.factory<_i773.OpenShiftCubit>(
      () => _i773.OpenShiftCubit(gh<_i119.ShiftUseCaseRepo>()),
    );
    gh.factory<_i722.ShiftCubit>(
      () => _i722.ShiftCubit(gh<_i119.ShiftUseCaseRepo>()),
    );
    gh.factory<_i183.AuditItemsUseCaseRepo>(
      () => _i56.AuditItemsUseCase(gh<_i291.AuditItemsRepository>()),
    );
    gh.factory<_i795.StoresUseCaseRepo>(
      () => _i1044.StoresUseCase(gh<_i592.StoresRepository>()),
    );
    gh.factory<_i1055.StoresCubit>(
      () => _i1055.StoresCubit(gh<_i795.StoresUseCaseRepo>()),
    );
    gh.factory<_i274.AuditItemsCubit>(
      () => _i274.AuditItemsCubit(gh<_i183.AuditItemsUseCaseRepo>()),
    );
    gh.factory<_i613.SearchProductsCubit>(
      () => _i613.SearchProductsCubit(gh<_i183.AuditItemsUseCaseRepo>()),
    );
    gh.factory<_i891.SearchAuditUserCubit>(
      () => _i891.SearchAuditUserCubit(gh<_i183.AuditItemsUseCaseRepo>()),
    );
    gh.factory<_i102.UpdateItemsStatusCubit>(
      () => _i102.UpdateItemsStatusCubit(gh<_i183.AuditItemsUseCaseRepo>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
