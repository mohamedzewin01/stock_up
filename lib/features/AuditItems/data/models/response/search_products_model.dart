import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/AuditItems/domain/entities/audit_items_entities.dart';

part 'search_products_model.g.dart';

@JsonSerializable()
class SearchProductsModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "store")
  final Store? store;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "total_items")
  final int? totalItems;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "results")
  final List<Results>? results;

  SearchProductsModel({
    this.status,
    this.store,
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.results,
  });

  factory SearchProductsModel.fromJson(Map<String, dynamic> json) {
    return _$SearchProductsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchProductsModelToJson(this);
  }

  SearchProductsEntity toEntity() {
    return SearchProductsEntity(
      status: status,
      store: store,
      page: page,
      limit: limit,
      totalItems: totalItems,
      totalPages: totalPages,
      results: results,
    );
  }
}

@JsonSerializable()
class Store {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;

  Store({this.id, this.name});

  factory Store.fromJson(Map<String, dynamic> json) {
    return _$StoreFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoreToJson(this);
  }
}

@JsonSerializable()
class Results {
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "product_number")
  final int? productNumber;
  @JsonKey(name: "product_name")
  final String? productName;
  @JsonKey(name: "total_quantity")
  final String? totalQuantity;
  @JsonKey(name: "unit")
  final String? unit;
  @JsonKey(name: "selling_price")
  final String? sellingPrice;
  @JsonKey(name: "average_purchase_price")
  final String? averagePurchasePrice;
  @JsonKey(name: "last_purchase_price")
  final String? lastPurchasePrice;
  @JsonKey(name: "category_id")
  final dynamic? categoryId;
  @JsonKey(name: "category_name")
  final dynamic? categoryName;
  @JsonKey(name: "taxable")
  final int? taxable;
  @JsonKey(name: "tax_rate")
  final String? taxRate;
  @JsonKey(name: "barcodes")
  final List<dynamic>? barcodes;

  Results({
    this.productId,
    this.productNumber,
    this.productName,
    this.totalQuantity,
    this.unit,
    this.sellingPrice,
    this.averagePurchasePrice,
    this.lastPurchasePrice,
    this.categoryId,
    this.categoryName,
    this.taxable,
    this.taxRate,
    this.barcodes,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return _$ResultsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResultsToJson(this);
  }
}
