import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/Search/domain/entities/search_entity.dart';

import '../../domain/useCases/Search_useCase_repo.dart';

part 'Search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchUseCaseRepo) : super(SearchInitial());
  final SearchUseCaseRepo _searchUseCaseRepo;

  Future<void> search(String? query, int? page) async {
    emit(SearchLoading());
    final result = await _searchUseCaseRepo.search(query, page);
    switch (result) {
      case Success<SearchEntity?>():
        emit(SearchSuccess(result.data));
        break;
      case Fail<SearchEntity?>():
        emit(SearchFailure(result.exception));
        break;
    }
  }
}
