import 'package:json_annotation/json_annotation.dart';

part 'add_barcode_request.g.dart';

@JsonSerializable()
class AddBarcodeRequest {
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

  AddBarcodeRequest ({
    this.productId,
    this.barcode,
    this.barcodeType,
    this.unitQuantity,
    this.unitPrice,
  });

  factory AddBarcodeRequest.fromJson(Map<String, dynamic> json) {
    return _$AddBarcodeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddBarcodeRequestToJson(this);
  }
}


