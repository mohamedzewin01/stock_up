import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Search/domain/entities/search_entity.dart';

import '../repositories/Search_repository.dart';
import '../useCases/Search_useCase_repo.dart';

@Injectable(as: SearchUseCaseRepo)
class SearchUseCase implements SearchUseCaseRepo {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  @override
  Future<Result<SearchEntity?>> search(String? query, int? page) {
    return repository.search(query, page);
  }

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
