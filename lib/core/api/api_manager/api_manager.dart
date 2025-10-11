import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stock_up/features/barcode_screen/data/models/response/smart_search_Model.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';

import '../api_constants.dart';

part 'api_manager.g.dart';

@injectable
@singleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  @FactoryMethod()
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.getStore)
  Future<AllStoresModel?> getStore();


  @POST(ApiConstants.smartSearch)
  Future<SmartSearchModel?> smartSearch(
      @Query("store_id") String storeId,
      @Query("q") String query
      );
}
