// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_barcode_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteBarcodeRequest _$DeleteBarcodeRequestFromJson(
  Map<String, dynamic> json,
) => DeleteBarcodeRequest(
  productId: (json['product_id'] as num?)?.toInt(),
  barcode: json['barcode'] as String?,
);

Map<String, dynamic> _$DeleteBarcodeRequestToJson(
  DeleteBarcodeRequest instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'barcode': instance.barcode,
};
