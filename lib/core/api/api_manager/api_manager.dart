import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/data/models/response/smart_search_Model.dart';

import '../api_constants.dart';

part 'api_manager.g.dart';

@injectable
@singleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  @FactoryMethod()
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.smartSearch)
  Future<SmartSearchModel?> smartSearch(@Query("q") String query);
}
