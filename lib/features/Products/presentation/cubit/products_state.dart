import 'package:equatable/equatable.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoadedFromLocal extends ProductsState {
  final List<Results> products;
  final Store? storeInfo;

  const ProductsLoadedFromLocal({required this.products, this.storeInfo});

  @override
  List<Object?> get props => [products, storeInfo];
}

class ProductsSyncing extends ProductsState {
  final List<Results> currentProducts;

  const ProductsSyncing(this.currentProducts);

  @override
  List<Object?> get props => [currentProducts];
}

class ProductsSynced extends ProductsState {
  final List<Results> products;
  final Store? storeInfo;
  final DateTime syncTime;

  const ProductsSynced({
    required this.products,
    this.storeInfo,
    required this.syncTime,
  });

  @override
  List<Object?> get props => [products, storeInfo, syncTime];
}

class ProductsSearchResult extends ProductsState {
  final List<Results> searchResults;
  final String query;

  const ProductsSearchResult({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

class ProductsError extends ProductsState {
  final String message;
  final List<Results>? cachedProducts;

  const ProductsError({required this.message, this.cachedProducts});

  @override
  List<Object?> get props => [message, cachedProducts];
}
