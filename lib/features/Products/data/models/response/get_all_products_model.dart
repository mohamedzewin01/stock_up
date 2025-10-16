import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Products/domain/entities/products_entities.dart';

part 'get_all_products_model.g.dart';

@JsonSerializable()
class GetAllProductsModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "store")
  final Store? store;
  @JsonKey(name: "total_items")
  final int? totalItems;
  @JsonKey(name: "results")
  final List<Results>? results;

  GetAllProductsModel({this.status, this.store, this.totalItems, this.results});

  factory GetAllProductsModel.fromJson(Map<String, dynamic> json) {
    return _$GetAllProductsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetAllProductsModelToJson(this);
  }

  GetAllProductsEntity toEntity() {
    return GetAllProductsEntity(
      status: status,
      store: store,
      totalItems: totalItems,
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
  final String? productId;
  @JsonKey(name: "product_number")
  final String? productNumber;
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
  final String? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "taxable")
  final String? taxable;
  @JsonKey(name: "tax_rate")
  final String? taxRate;
  @JsonKey(name: "barcodes")
  final List<String>? barcodes;

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
