import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/data/models/response/login_model.dart';
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

  @POST(ApiConstants.search)
  Future<SearchModel?> search(@Body() SearchRequest searchRequest);
}
