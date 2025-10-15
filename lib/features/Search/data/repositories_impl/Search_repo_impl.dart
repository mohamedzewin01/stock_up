import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Search/data/datasources/Search_datasource_repo.dart';
import 'package:stock_up/features/Search/domain/entities/search_entity.dart';

import '../../domain/repositories/Search_repository.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasourceRepo datasourceRepo;

  SearchRepositoryImpl(this.datasourceRepo);

  @override
  Future<Result<SearchEntity?>> search(String? query, int? page) {
    return datasourceRepo.search(query, page);
  }

  // implementation
}
