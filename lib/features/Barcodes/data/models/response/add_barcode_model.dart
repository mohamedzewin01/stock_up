import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

part 'add_barcode_model.g.dart';

@JsonSerializable()
class AddBarcodeModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "barcode")
  final String? barcode;
  @JsonKey(name: "barcode_type")
  final String? barcodeType;
  @JsonKey(name: "unit_quantity")
  final int? unitQuantity;
  @JsonKey(name: "unit_price")
  final double? unitPrice;

  AddBarcodeModel({
    this.status,
    this.message,
    this.productId,
    this.barcode,
    this.barcodeType,
    this.unitQuantity,
    this.unitPrice,
  });

  factory AddBarcodeModel.fromJson(Map<String, dynamic> json) {
    return _$AddBarcodeModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddBarcodeModelToJson(this);
  }

  AddBarcodeEntity toEntity() {
    return AddBarcodeEntity(
      status: status,
      message: message,
      productId: productId,
      barcode: barcode,
      barcodeType: barcodeType,
      unitQuantity: unitQuantity,
      unitPrice: unitPrice,
    );
  }
}
