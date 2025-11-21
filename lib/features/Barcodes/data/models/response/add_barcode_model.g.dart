// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_barcode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBarcodeModel _$AddBarcodeModelFromJson(Map<String, dynamic> json) =>
    AddBarcodeModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      productId: (json['product_id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      barcodeType: json['barcode_type'] as String?,
      unitQuantity: (json['unit_quantity'] as num?)?.toInt(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddBarcodeModelToJson(AddBarcodeModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'product_id': instance.productId,
      'barcode': instance.barcode,
      'barcode_type': instance.barcodeType,
      'unit_quantity': instance.unitQuantity,
      'unit_price': instance.unitPrice,
    };
