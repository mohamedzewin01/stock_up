part of 'Search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  final SearchEntity? searchEntity;

  SearchSuccess(this.searchEntity);
}

final class SearchFailure extends SearchState {
  final Exception exception;

  SearchFailure(this.exception);
}
