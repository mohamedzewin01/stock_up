import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';

part 'smart_search_Model.g.dart';

@JsonSerializable()
class SmartSearchModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "source")
  final String? source;
  @JsonKey(name: "results")
  final List<Results>? results;

  SmartSearchModel ({
    this.status,
    this.source,
    this.results,
  });

  factory SmartSearchModel.fromJson(Map<String, dynamic> json) {
    return _$SmartSearchModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SmartSearchModelToJson(this);
  }
  SmartSearchEntity toEntity() {
    return SmartSearchEntity(
      status: status,
      source: source,
      results: results,
    );
  }
}

@JsonSerializable()
class Results {
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
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "taxable")
  final int? taxable;
  @JsonKey(name: "tax_rate")
  final String? taxRate;
  @JsonKey(name: "barcodes")
  final dynamic? barcodes;
  @JsonKey(name: "image_front_url")
  final dynamic? imageFrontUrl;
  @JsonKey(name: "image_ingredients_url")
  final dynamic? imageIngredientsUrl;
  @JsonKey(name: "image_nutrition_url")
  final dynamic? imageNutritionUrl;

  Results ({
    this.productNumber,
    this.productName,
    this.totalQuantity,
    this.unit,
    this.sellingPrice,
    this.averagePurchasePrice,
    this.lastPurchasePrice,
    this.category,
    this.taxable,
    this.taxRate,
    this.barcodes,
    this.imageFrontUrl,
    this.imageIngredientsUrl,
    this.imageNutritionUrl,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return _$ResultsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResultsToJson(this);
  }
}


