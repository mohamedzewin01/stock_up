// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_barcode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteBarcodeModel _$DeleteBarcodeModelFromJson(Map<String, dynamic> json) =>
    DeleteBarcodeModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      productId: (json['product_id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$DeleteBarcodeModelToJson(DeleteBarcodeModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'product_id': instance.productId,
      'barcode': instance.barcode,
    };
