import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/data/models/response/login_model.dart';
import 'package:stock_up/features/Inventory/data/models/request/add_inventory_audit_users_request.dart';
import 'package:stock_up/features/Inventory/data/models/request/create_inventory_audit_request.dart';
import 'package:stock_up/features/Inventory/data/models/request/get_inventory_by_user_request.dart';
import 'package:stock_up/features/Inventory/data/models/response/add_inventory_audit_users_model.dart';
import 'package:stock_up/features/Inventory/data/models/response/create_inventory_audit_model.dart';
import 'package:stock_up/features/Inventory/data/models/response/get_all_users_model.dart';
import 'package:stock_up/features/Inventory/data/models/response/get_inventory_by_user_model.dart';
import 'package:stock_up/features/Products/data/models/request/get_all_products_request.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';

import '../../../features/Search/data/models/request/search_request.dart';
import '../../../features/Search/data/models/response/search_model.dart';
import '../api_constants.dart';

part 'api_manager.g.dart';

@injectable
@singleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  @FactoryMethod()
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginModel?> login(@Body() LoginRequest loginRequest);

  @POST(ApiConstants.getStore)
  Future<AllStoresModel?> getStore();

  @POST(ApiConstants.getAllProducts)
  Future<GetAllProductsModel?> getAllProducts(
    @Body() GetAllProductsRequest getAllProductsRequest,
  );

  @POST(ApiConstants.createInventoryAudit)
  Future<CreateInventoryAuditModel?> createInventoryAudit(
    @Body() CreateInventoryAuditRequest createInventoryAuditRequest,
  );

  @POST(ApiConstants.addInventoryAuditUsers)
  Future<AddInventoryAuditUsersModel?> addInventoryAuditUsers(
    @Body() AddInventoryAuditUsersRequest addInventoryAuditUsersRequest,
  );

  @POST(ApiConstants.getInventoryByUser)
  Future<GetInventoryByUserModel?> getInventoryByUser(
    @Body() GetInventoryByUserRequest getInventoryByUserRequest,
  );

  @POST(ApiConstants.getAllUsers)
  Future<GetAllUsersModel?> getAllUsers();

  @POST(ApiConstants.search)
  Future<SearchModel?> search(@Body() SearchRequest searchRequest);
}
