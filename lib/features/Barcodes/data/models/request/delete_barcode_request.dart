import 'package:json_annotation/json_annotation.dart';

part 'delete_barcode_request.g.dart';

@JsonSerializable()
class DeleteBarcodeRequest {
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "barcode")
  final String? barcode;

  DeleteBarcodeRequest ({
    this.productId,
    this.barcode,
  });

  factory DeleteBarcodeRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteBarcodeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteBarcodeRequestToJson(this);
  }
}


