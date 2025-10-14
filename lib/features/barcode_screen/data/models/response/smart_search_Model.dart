// import 'package:json_annotation/json_annotation.dart';
// import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';
//
// part 'smart_search_Model.g.dart';
//
// @JsonSerializable()
// class SmartSearchModel {
//   @JsonKey(name: "status")
//   final String? status;
//   @JsonKey(name: "store")
//   final Store? store;
//   @JsonKey(name: "results")
//   final List<Results>? results;
//
//   SmartSearchModel ({
//     this.status,
//     this.store,
//     this.results,
//   });
//
//   factory SmartSearchModel.fromJson(Map<String, dynamic> json) {
//     return _$SmartSearchModelFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$SmartSearchModelToJson(this);
//   }
//   SmartSearchEntity toEntity() {
//     return SmartSearchEntity(
//       status: status,
//       store: store,
//       results: results,
//     );
//   }
// }
//
// @JsonSerializable()
// class Store {
//   @JsonKey(name: "id")
//   final String? id;
//   @JsonKey(name: "name")
//   final String? name;
//
//   Store ({
//     this.id,
//     this.name,
//   });
//
//   factory Store.fromJson(Map<String, dynamic> json) {
//     return _$StoreFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$StoreToJson(this);
//   }
// }
//
// @JsonSerializable()
// class Results {
//   @JsonKey(name: "product_id")
//   final int? productId;
//   @JsonKey(name: "product_number")
//   final int? productNumber;
//   @JsonKey(name: "product_name")
//   final String? productName;
//   @JsonKey(name: "total_quantity")
//   final String? totalQuantity;
//   @JsonKey(name: "unit")
//   final String? unit;
//   @JsonKey(name: "selling_price")
//   final String? sellingPrice;
//   @JsonKey(name: "average_purchase_price")
//   final String? averagePurchasePrice;
//   @JsonKey(name: "last_purchase_price")
//   final String? lastPurchasePrice;
//   @JsonKey(name: "category_id")
//   final int? categoryId;
//   @JsonKey(name: "taxable")
//   final int? taxable;
//   @JsonKey(name: "tax_rate")
//   final String? taxRate;
//   @JsonKey(name: "barcodes")
//   final List<String>? barcodes;
//
//   Results ({
//     this.productId,
//     this.productNumber,
//     this.productName,
//     this.totalQuantity,
//     this.unit,
//     this.sellingPrice,
//     this.averagePurchasePrice,
//     this.lastPurchasePrice,
//     this.categoryId,
//     this.taxable,
//     this.taxRate,
//     this.barcodes,
//   });
//
//   factory Results.fromJson(Map<String, dynamic> json) {
//     return _$ResultsFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$ResultsToJson(this);
//   }
// }
//
//
