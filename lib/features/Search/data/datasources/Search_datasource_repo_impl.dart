import 'package:injectable/injectable.dart';
import 'package:stock_up/core/api/api_extentions.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Search/data/models/request/search_request.dart';
import 'package:stock_up/features/Search/domain/entities/search_entity.dart';

import '../../../../core/api/api_manager/api_manager.dart';
import 'Search_datasource_repo.dart';

@Injectable(as: SearchDatasourceRepo)
class SearchDatasourceRepoImpl implements SearchDatasourceRepo {
  final ApiService apiService;

  SearchDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<SearchEntity?>> search(String? query, int? page) {
    SearchRequest searchRequest = SearchRequest(
      limit: 10,
      page: page ?? 1,
      q: query,
      storeId: CacheService.getData(key: CacheKeys.storeId).toString(),
    );
    return executeApi(() async {
      final result = await apiService.search(searchRequest);
      return result?.toEntity();
    });
  }
}
