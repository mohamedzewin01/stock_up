import 'package:json_annotation/json_annotation.dart';
import 'package:stock_up/features/Barcodes/domain/entities/barcodes_entities.dart';

part 'delete_barcode_model.g.dart';

@JsonSerializable()
class DeleteBarcodeModel {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "barcode")
  final String? barcode;

  DeleteBarcodeModel({this.status, this.message, this.productId, this.barcode});

  factory DeleteBarcodeModel.fromJson(Map<String, dynamic> json) {
    return _$DeleteBarcodeModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteBarcodeModelToJson(this);
  }

  DeleteBarcodeEntity toEntity() {
    return DeleteBarcodeEntity(
      status: status,
      message: message,
      productId: productId,
      barcode: barcode,
    );
  }
}
