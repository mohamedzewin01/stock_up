import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Search/domain/entities/search_entity.dart';

abstract class SearchUseCaseRepo {
  Future<Result<SearchEntity?>> search(String? query, int? page);
}
