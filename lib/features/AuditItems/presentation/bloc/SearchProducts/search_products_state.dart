part of 'search_products_cubit.dart';

@immutable
sealed class SearchProductsState {}

final class SearchProductsInitial extends SearchProductsState {}

final class SearchProductsLoading extends SearchProductsState {}

final class SearchProductsSuccess extends SearchProductsState {
  final SearchProductsEntity? searchProductsEntity;

  SearchProductsSuccess({required this.searchProductsEntity});
}

final class SearchProductsFailure extends SearchProductsState {
  final Exception exception;

  SearchProductsFailure(this.exception);
}
