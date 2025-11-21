// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_barcode_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBarcodeRequest _$AddBarcodeRequestFromJson(Map<String, dynamic> json) =>
    AddBarcodeRequest(
      productId: (json['product_id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      barcodeType: json['barcode_type'] as String?,
      unitQuantity: (json['unit_quantity'] as num?)?.toInt(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddBarcodeRequestToJson(AddBarcodeRequest instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'barcode': instance.barcode,
      'barcode_type': instance.barcodeType,
      'unit_quantity': instance.unitQuantity,
      'unit_price': instance.unitPrice,
    };
